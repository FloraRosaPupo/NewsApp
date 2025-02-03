class NotFoundException implements Exception{
  final String message;//personalizar a mensagem 

  NotFoundException({required this.message});
}