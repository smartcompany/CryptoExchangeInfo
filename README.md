# CryptoExchangeInfo

해외 거래소 이벤트·Flexible Earn 정보를 보여주는 Flutter 앱입니다.  
지원: 바이비트, 바이낸스, OKX, 업비트, 빗썸, Bitget · iOS / Android / Web.

## API

| 용도 | 방식 |
|------|------|
| 이벤트·Earn·이미지 | 앱이 거래소 공개 API를 **직접** 호출 |
| 설정·AI 분석 | `https://cryptoexchangeinfoserver.vercel.app` |

## 실행

```bash
flutter pub get
flutter run
```

## 주요 기능

- 거래소별 이벤트·기회 카드 (보상·마감·유형 필터)
- Flexible USDT Earn 목록
- Drift(SQLite) 로컬 캐시

> 제공 정보는 참고용이며 투자 권유가 아닙니다.
