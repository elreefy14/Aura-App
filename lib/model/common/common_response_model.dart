class CommonResponse<T> {
  final bool isSuccess;
  final String message;
  T? response;
  CommonResponse(
      {required this.isSuccess, required this.message, this.response});
}
