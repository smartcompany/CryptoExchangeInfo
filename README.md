# CryptoExchangeInfo

해외 거래소 이벤트·Flexible Earn 정보를 보여주는 Flutter 앱입니다.  
지원: 바이비트, 바이낸스, OKX, 업비트, 빗썸, Bitget · iOS / Android / Web.

## API

| 용도 | 방식 |
|------|------|
| 이벤트·Earn·이미지 | 앱이 거래소 공개 API를 **직접** 호출 |
| 설정·AI 분석 | Vercel 또는 Cloudflare Workers (아래) |

설정·AI 서버 선택 (`lib/services/exchange_events_service.dart`):

- 코드: `ApiBackend.activeApiBackend` → `railway` / `vercel` / `cloudflare`
- 또는 실행 시: `--dart-define=EXORA_API_BACKEND=vercel`

| 백엔드 | URL |
|--------|-----|
| Railway (기본) | `https://cryptoexchangeinfoserver-production.up.railway.app` |
| Vercel | `https://cryptoexchangeinfoserver.vercel.app` |
| Cloudflare | `https://cryptoexchangeinfoserver.gunnylove.workers.dev` |

## 실행

```bash
flutter pub get
flutter run
# Cloudflare Workers 로 테스트:
flutter run --dart-define=EXORA_API_BACKEND=cloudflare
```

## 스토어 빌드·메타데이터

`deployment-kit/` (다른 앱 키트와 동일 패턴):

```bash
cp deployment-kit/asc-metadata/.env.example deployment-kit/asc-metadata/.env
./update_ios_meta.sh --dry-run
./ios_build_with_version.sh --bump          # fastlane → App Store Connect
./build_with_version.sh                     # AAB
./update_android_meta.sh --dry-run
./deployment-kit/scripts/upload_android_aab.sh --track internal
```

자세한 내용: [deployment-kit/README.md](./deployment-kit/README.md)

## 주요 기능

- 거래소별 이벤트·기회 카드 (보상·마감·유형 필터)
- Flexible USDT Earn 목록
- Drift(SQLite) 로컬 캐시

> 제공 정보는 참고용이며 투자 권유가 아닙니다.
