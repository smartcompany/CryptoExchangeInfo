# App Store Connect — 메타데이터 업로드 (Exora)

- **Bundle ID:** `com.smartcompany.cryptoExchangeInfo`
- **스토어 앱명:** Exora - Crypto Exchange Hub
- **홈 화면 이름:** Exora

## 파일

| 파일 | 내용 |
|------|------|
| `listings.mjs` | 로케일별 스토어 문구 |
| `store-urls.mjs` | privacy / support / marketing / copyright (`app-config.json`) |
| `whats-new.json` | What's New |
| `review-notes.txt` | App Review Notes |

## 1회 설정

```bash
cd client/deployment-kit/asc-metadata
cp .env.example .env
# ASC_ISSUER_ID 확인
```

앱이 Connect에 없으면 `update-metadata.sh`가 `fastlane produce`로 생성 시도합니다.  
번들 ID는 먼저 [Apple Developer Identifiers](https://developer.apple.com/account/resources/identifiers/list)에 등록돼 있어야 합니다.

## 사용

```bash
# from client/
./deployment-kit/scripts/upload_ios_metadata.sh --dry-run
./deployment-kit/scripts/upload_ios_metadata.sh
./deployment-kit/scripts/upload_ios_metadata.sh --only reviewNotes
./deployment-kit/scripts/upload_ios_metadata.sh --only whatsNew
```
