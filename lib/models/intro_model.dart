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
      title: "Don't worry about too many cards.",
      description: "With BusinessCode, you can add and share various types of cards, such as business cards, ID cards, and pass card.",
      illustration: "intro_1",
      buttonText: "Start",
    ),
    IntroModel(
      title: "Save it on your iOS wallet or our app",
      description: "You can save a copy of your cards on the iOS wallet or on the Business Card app with just a click.",
      illustration: "intro_2",
      buttonText: "Next",
    ),
    IntroModel(
      title: "Share it with others easily",
      description: "With Business Code, easily share your cards with others via a link or by scanning the QR code.",
      illustration: "intro_3",
      buttonText: "Next",
    ),
  ];
}
