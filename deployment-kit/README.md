# Deployment Kit — Exora

배포 직전마다 AI에게 여러 번 설명하지 않도록 만든 단일 폴더입니다.  
(참고 템플릿: 다른 앱의 `client/deployment-kit` — AIPhotoSearch에는 키트가 없어 AIFindProducts/UseByDate 패턴을 이식)

## 구조

```
deployment-kit/
├── app-config.json          # bundle id, URL, 키 경로
├── app-config.example.json
├── asc-metadata/            # App Store Connect 메타데이터
├── play-metadata/           # Google Play 메타데이터
└── scripts/
    ├── build_android.sh
    ├── build_ios.sh
    ├── upload_ios_metadata.sh
    ├── upload_android_metadata.sh
    ├── upload_android_aab.sh
    ├── release_all.sh
    ├── release_ios_all.sh
    └── release_android_all.sh
```

## 사용법

`client/` 에서:

```bash
# 1회: ASC Issuer
cp deployment-kit/asc-metadata/.env.example deployment-kit/asc-metadata/.env
# Play (선택)
cp deployment-kit/play-metadata/.env.example deployment-kit/play-metadata/.env

# iOS 전체 (메타 + 빌드/업로드)
./deployment-kit/scripts/release_ios_all.sh

# Android 전체 (빌드 + 메타)
./deployment-kit/scripts/release_android_all.sh

# 개별
./deployment-kit/scripts/upload_ios_metadata.sh --dry-run
./deployment-kit/scripts/upload_android_metadata.sh --dry-run
./deployment-kit/scripts/build_ios.sh --bump
./deployment-kit/scripts/build_android.sh
./deployment-kit/scripts/upload_android_aab.sh --track internal
```

래퍼:

```bash
./update_ios_meta.sh --dry-run
./update_android_meta.sh --dry-run
./ios_build_with_version.sh --bump
./build_with_version.sh
```

## 설정

- `app-config.json`: 앱명, bundle/package id, URL, ASC/Android 키 경로, review contact
- `asc-metadata/listings.mjs`: App Store 문구 (스토어명 **Exora - Crypto Exchange Hub**)
- `play-metadata/`: Play 업로드 (문구는 listings 재사용)

자세한 내용: `asc-metadata/README.md`, `play-metadata/README.md`
