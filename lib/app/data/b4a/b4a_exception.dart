class B4aException implements Exception {
  final String message;
  final String where;
  final String originalError;
  B4aException(this.message, {this.where = '', this.originalError = ''});

  @override
  String toString() => message;
}
