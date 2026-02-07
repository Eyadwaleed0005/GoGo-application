class SuggestedPriceCalculator {
  static int calculate({
    required double distanceKm,
    required String tripType, // one_of_group, two_of_group, three_of_group, lone_trip, delivery
    required String carType,  // taxi, car, scooter
  }) {
    double price = 0;

    // 🚗 الحالة 1: العربية
    if (carType == "car") {
      // 🟢 لو الرحلة دليفري → نفس تسعيرة الدليفري القديمة
      if (tripType == "delivery") {
        if (distanceKm <= 2) {
          price = 10;
        } else if (distanceKm > 2 && distanceKm <= 4) {
          price = 25;
        } else if (distanceKm > 4 && distanceKm <= 8) {
          price = 32;
        } else {
          price = 40;
        }
      } else {
        if (distanceKm <= 1) {
          price = 15;
        } else if (distanceKm <= 2) {
          price = 30; // أول كيلوين (15 + 15)
        } else if (distanceKm <= 3) {
          price = 34; // (15 + 15 + 4)
        } else {
          price = 34 + ((distanceKm - 3) * 4);
        }
      }
      return price.ceil();
    }
    if (carType == "taxi") {
      double extraKm = distanceKm - 2;

      if (tripType == "delivery") {
        if (distanceKm <= 2) {
          price = 10;
        } else if (distanceKm > 2 && distanceKm <= 4) {
          price = 25;
        } else if (distanceKm > 4 && distanceKm <= 8) {
          price = 32;
        } else {
          price = 40;
        }
      } else {
        // 🚕 حسب نوع الرحلة
        if (tripType != "delivery" && distanceKm <= 2) {
          return 17;
        }
        if (tripType == "one_of_group") {
          price = 17 + (extraKm * 2);
        } else if (tripType == "two_of_group") {
          price = 17 + (extraKm * 3);
        } else if (tripType == "three_of_group") {
          price = 17 + (extraKm * 4);
        } else if (tripType == "lone_trip") {
          price = 17 + (extraKm * 4);
        }
      }
      return price.ceil();
    }

    // 🛵 الحالة 3: الأسكوتر
    if (carType == "scooter") {
      if (tripType == "delivery") {
        // 📦 نفس تسعيرة الدليفري القديمة
        if (distanceKm <= 2) {
          price = 10;
        } else if (distanceKm > 2 && distanceKm <= 4) {
          price = 25;
        } else if (distanceKm > 4 && distanceKm <= 8) {
          price = 32;
        } else {
          price = 40;
        }
      } else {
        if (distanceKm <= 2) {
          price = 17;
        } else {
          double extraKm = distanceKm - 2;
          price = 17 + (extraKm * 2);
        }
      }
      return price.ceil();
    }

    if (tripType == "delivery" || carType == "delivery") {
      if (distanceKm <= 2) {
        price = 10;
      } else if (distanceKm > 2 && distanceKm <= 4) {
        price = 25;
      } else if (distanceKm > 4 && distanceKm <= 8) {
        price = 32;
      } else {
        price = 40;
      }
      return price.ceil();
    }
    return 17;
  }
}
