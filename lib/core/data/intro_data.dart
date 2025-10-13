import '../models/intro_model.dart';
import '../../features/intro/presentation/widgets/intro_illustrations.dart';

class IntroData {
  static final List<IntroModel> introScreens = [
    IntroModel(
      title: 'scan_cards',
      description: 'scan_cards_description',
      illustration: IntroIllustrations.getIllustration('intro_1'),
    ),
    IntroModel(
      title: 'organize_contacts',
      description: 'organize_contacts_description',
      illustration: IntroIllustrations.getIllustration('intro_2'),
    ),
    IntroModel(
      title: 'easy_access',
      description: 'easy_access_description',
      illustration: IntroIllustrations.getIllustration('intro_3'),
    ),
  ];
}

