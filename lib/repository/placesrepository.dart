import 'package:commute_nepal/response/places_response.dart';
import 'package:commute_nepal/api/getplacesapi.dart';

class PlacesRepository {
  Future<PlacesResponse?> getplaces({required String keyword}) async {
    return PlacesAPI().fetchplacesfromapi(search: keyword);
  }
}
