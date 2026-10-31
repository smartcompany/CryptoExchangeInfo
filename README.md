# CryptoExchangeInfo

해외 거래소 이벤트·Flexible Earn 정보를 보여주는 Flutter 앱입니다.  
지원: 바이비트, 바이낸스, OKX, 업비트, 빗썸, Bitget · iOS / Android / Web.

## 실행

```bash
# 의존성
flutter pub get

# 로컬 API 프록시는 상위 폴더의 server/ 를 사용합니다.
# cd ../server && dart pub get && dart run bin/server.dart
# 기본: http://localhost:8787

flutter run
```

앱은 기본적으로 `http://localhost:8787` 프록시에 연결합니다.  
Android 에뮬레이터는 `http://10.0.2.2:8787` 을 사용합니다.

## 주요 기능

- 거래소별 이벤트·기회 카드 (보상·마감·유형 필터)
- Flexible USDT Earn 목록
- Drift(SQLite) 로컬 캐시

> 제공 정보는 참고용이며 투자 권유가 아닙니다.
