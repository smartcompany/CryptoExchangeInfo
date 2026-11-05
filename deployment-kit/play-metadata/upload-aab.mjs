#!/usr/bin/env node
/**
 * Upload a release AAB to a Play track (default: production).
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  createAndroidPublisher,
  isEditConflictError,
  isPackageNotFoundError,
  readWhatsNew,
  requirePlayEnv,
  withEdit,
} from './lib/play.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CLIENT_DIR = path.resolve(__dirname, '../..');
const DEFAULT_AAB = path.join(
  CLIENT_DIR,
  'build/app/outputs/bundle/release/app-release.aab',
);

function parseArgs(argv) {
  const args = {
    dryRun: false,
    track: process.env.PLAY_UPLOAD_TRACK?.trim() || 'production',
    aab: process.env.PLAY_AAB_PATH?.trim() || DEFAULT_AAB,
    status: 'completed',
    whatsNewFile: path.join(__dirname, '../asc-metadata/whats-new.json'),
    help: false,
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--dry-run') args.dryRun = true;
    else if (a === '--track') args.track = argv[++i];
    else if (a === '--aab') args.aab = path.resolve(argv[++i]);
    else if (a === '--status') args.status = argv[++i];
    else if (a === '--whats-new') args.whatsNewFile = path.resolve(argv[++i]);
    else if (a === '--help' || a === '-h') args.help = true;
  }
  return args;
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function isVersionAlreadyUsedError(err) {
  const msg = String(err?.message ?? err);
  return /version code .* already (been )?used/i.test(msg);
}

async function uploadOnce(androidpublisher, packageName, args, releaseNotes) {
  return withEdit(androidpublisher, packageName, async (editId) => {
    console.log('Uploading bundle…');
    let versionCode;
    try {
      const { data: bundle } = await androidpublisher.edits.bundles.upload({
        packageName,
        editId,
        media: {
          mimeType: 'application/octet-stream',
          body: fs.createReadStream(args.aab),
        },
      });
      versionCode = bundle.versionCode;
    } catch (err) {
      if (!isVersionAlreadyUsedError(err)) throw err;
      // Same versionCode already on Play — still attach it to the track.
      const m = String(err.message).match(/version code\s+(\d+)/i);
      versionCode = m ? Number(m[1]) : null;
      if (versionCode == null) throw err;
      console.log(
        `⚠ versionCode=${versionCode} already on Play — assigning track only`,
      );
    }

    if (versionCode == null) {
      throw new Error('bundles.upload returned no versionCode');
    }
    console.log(`✓ bundle ready versionCode=${versionCode}`);

    const release = {
      name: String(versionCode),
      versionCodes: [String(versionCode)],
      status: args.status,
    };
    if (releaseNotes.length > 0) {
      release.releaseNotes = releaseNotes;
    }

    await androidpublisher.edits.tracks.update({
      editId,
      packageName,
      track: args.track,
      requestBody: {
        track: args.track,
        releases: [release],
      },
    });
    console.log(`✓ assigned to track "${args.track}" (${args.status})`);
    return versionCode;
  });
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(`Usage: node upload-aab.mjs [options]

Upload app-release.aab to a Play track (production by default).

Options:
  --aab PATH           Default: client/build/app/outputs/bundle/release/app-release.aab
  --track production   internal | alpha | beta | production
  --status completed   completed (testers get it) | draft
  --whats-new FILE     Optional notes from ../asc-metadata/whats-new.json
  --dry-run
`);
    process.exit(0);
  }

  const aabPath = path.resolve(args.aab);
  args.aab = aabPath;
  if (!fs.existsSync(aabPath)) {
    throw new Error(`AAB not found: ${aabPath}\nRun build_android.sh first.`);
  }

  const notesByLocale = readWhatsNew(args.whatsNewFile);
  const releaseNotes = [...notesByLocale.entries()].map(([language, text]) => ({
    language,
    text,
  }));

  console.log(`AAB:    ${aabPath}`);
  console.log(`Track:  ${args.track}`);
  console.log(`Status: ${args.status}`);
  if (releaseNotes.length) {
    console.log(`Notes:  ${releaseNotes.map((n) => n.language).join(', ')}`);
  }

  if (args.dryRun) {
    console.log('\nDry-run — no upload.');
    return;
  }

  const { jsonPath, packageName } = requirePlayEnv(__dirname);
  console.log(`Package: ${packageName}`);

  const androidpublisher = await createAndroidPublisher(jsonPath);

  const maxAttempts = 3;
  let versionCode;
  try {
    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        versionCode = await uploadOnce(
          androidpublisher,
          packageName,
          args,
          releaseNotes,
        );
        break;
      } catch (err) {
        if (isEditConflictError(err) && attempt < maxAttempts) {
          console.warn(
            `Edit conflict (attempt ${attempt}/${maxAttempts}): ${err.message}`,
          );
          console.warn('Retrying with a fresh edit…');
          await sleep(2000 * attempt);
          continue;
        }
        throw err;
      }
    }
  } catch (err) {
    if (err?.code === 'PLAY_PACKAGE_NOT_FOUND' || isPackageNotFoundError(err)) {
      const error = new Error(`Package not found: ${packageName}.`);
      error.code = 'PLAY_PACKAGE_NOT_FOUND';
      throw error;
    }
    throw err;
  }

  if (versionCode == null) {
    throw new Error('Upload failed after retries (no versionCode).');
  }

  console.log(`\nDone — versionCode ${versionCode} committed to ${args.track}.`);
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(err?.code === 'PLAY_PACKAGE_NOT_FOUND' ? 2 : 1);
});
