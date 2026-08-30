class Questions {
  final String question;
  final List<String> options;
  final int answer;
  final String? image;

  Questions({
    required this.question,
    required this.options,
    required this.answer,
    this.image,
  });
}
