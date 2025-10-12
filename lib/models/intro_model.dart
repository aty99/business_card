class IntroModel {
  final String title;
  final String description;
  final String illustration;
  final String buttonText;

  const IntroModel({
    required this.title,
    required this.description,
    required this.illustration,
    required this.buttonText,
  });
}

class IntroData {
  static const List<IntroModel> introScreens = [
    IntroModel(
      title: "intro_1_title",
      description: "intro_1_description",
      illustration: "intro_1",
      buttonText: "start",
    ),
    IntroModel(
      title: "intro_2_title",
      description: "intro_2_description",
      illustration: "intro_2",
      buttonText: "next",
    ),
    IntroModel(
      title: "intro_3_title",
      description: "intro_3_description",
      illustration: "intro_3",
      buttonText: "next",
    ),
  ];
}
