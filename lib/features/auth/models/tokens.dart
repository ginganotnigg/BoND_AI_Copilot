class Tokens {
  final String accessToken;
  final String refreshToken;
  final bool isSuccess;
  final String message;

  Tokens(this.isSuccess, this.accessToken, this.refreshToken, this.message);
}