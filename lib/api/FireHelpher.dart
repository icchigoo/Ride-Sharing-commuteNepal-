import 'package:commute_nepal/model/nearby_drivers.dart';

class FireHelpher {
  static List<NearbyDrivers> nearbyDriversList = [];
  static void removeFromList(String key) {
    int index = nearbyDriversList.indexWhere((element) => element.key == key);
    nearbyDriversList.removeAt(index);
  }

  static void updateNearbyLocation(NearbyDrivers driver) {
    int index =
        nearbyDriversList.indexWhere((element) => element.key == driver.key);
    nearbyDriversList[index].latitude = driver.latitude;
    nearbyDriversList[index].longitude = driver.longitude;
  }
}
