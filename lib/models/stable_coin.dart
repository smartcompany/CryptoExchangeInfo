/// Major USD stables shown on the Stable Coin Earn tab.
enum StableCoin {
  usdt,
  usdc,
  fdusd,
  dai,
  tusd,
  usde,
  pyusd;

  String get symbol => switch (this) {
    StableCoin.usdt => 'USDT',
    StableCoin.usdc => 'USDC',
    StableCoin.fdusd => 'FDUSD',
    StableCoin.dai => 'DAI',
    StableCoin.tusd => 'TUSD',
    StableCoin.usde => 'USDE',
    StableCoin.pyusd => 'PYUSD',
  };
}
