class TripTypeTranslator {
  static String toArabic(String type) {
    switch (type) {
      case "one_of_group":
        return "رحلة فرد من مجموعة";
      case "two_of_group":
        return "رحلة فردين من مجموعة";
      case "three_of_group":
        return "رحلة ثلاثة من مجموعة";
      case "lone_trip":
        return "رحلة فردية";
      case "delivery":
        return "توصيل";
      default:
        return "غير معروف";
    }
  }
}
