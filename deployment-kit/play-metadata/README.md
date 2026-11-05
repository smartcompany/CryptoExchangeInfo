# Google Play — Exora

Google Play Console API용 메타데이터 업로드입니다.  
문구 원본: `../asc-metadata/listings.mjs` · URL/연락처: `../app-config.json`

| App Store (ASC) | Google Play | API 업로드 |
|-----------------|-------------|------------|
| `name` | `title` (≤30자) | ✅ |
| `subtitle` / `promotionalText` | `shortDescription` (≤80자) | ✅ |
| `description` | `fullDescription` (≤4000자) | ✅ |
| support / contact | details | ✅ |
| privacy URL | App content → Privacy policy | ❌ **Play Console 수동** |

Package: `com.smartcompany.cryptoExchangeInfo`  
로케일: `ko-KR`, `en-US`, `ja-JP`, `zh-CN`

## 설정

```bash
cd client/deployment-kit/play-metadata
cp .env.example .env
npm install
```

## 사용

```bash
# from client/
./deployment-kit/scripts/upload_android_metadata.sh --dry-run
./deployment-kit/scripts/upload_android_metadata.sh
./deployment-kit/scripts/upload_android_aab.sh --track internal
```
