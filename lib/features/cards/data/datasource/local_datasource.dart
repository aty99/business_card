// Cards Local DataSource
import '../model/card_model.dart';

class CardsLocalDataSource {
  Future<List<CardModel>> getAllCards() async {
    // TODO: استرجاع جميع البطاقات من التخزين المحلي
    return [];
  }

  Future<CardModel> addCard({
    required String title,
    required String description,
    required String ownerId,
  }) async {
    // TODO: إضافة بطاقة جديدة للتخزين المحلي
    return CardModel();
  }

  Future<void> deleteCard(String cardId) async {
    // TODO: حذف بطاقة من التخزين المحلي
  }

  Future<CardModel?> getCardById(String cardId) async {
    // TODO: استرجاع بطاقة واحدة حسب id
    return null;
  }
}
