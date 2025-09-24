class SuggestedPriceCalculator {
  static int calculate({
    required double distanceKm,
    required String tripType, // one_of_group, two_of_group, three_of_group, lone_trip, delivery
  }) {
    double price = 0;

    if (tripType != "delivery" && distanceKm <= 2) {
      return 17;
    }
    double extraKm = distanceKm - 2;
    if (tripType == "one_of_group") {
      price = 17 + (extraKm * 2);
    } else if (tripType == "two_of_group") {
      price = 17 + (extraKm * 3);
    } else if (tripType == "three_of_group") {
      price = 17 + (extraKm * 4);
    } else if (tripType == "lone_trip") {
      price = 17 + (extraKm * 4);
    } else if (tripType == "delivery") {
      if (distanceKm <= 2) {
        price = 10;
      } else if (distanceKm > 2 && distanceKm <= 4) {
        price = 25;
      } else if (distanceKm > 4 && distanceKm <= 8) {
        price = 32;
      } else {
        price = 40;
      }
    }

    return price.ceil();
  }
}
