import 'package:commute_nepal/model/places_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'places_response.g.dart';

@JsonSerializable()
class PlacesResponse {
  List<Features>? features;
  PlacesResponse({this.features});
  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return _$PlacesResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$PlacesResponseToJson(this);
}
