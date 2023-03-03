import 'package:json_annotation/json_annotation.dart';
part 'places_model.g.dart';

@JsonSerializable()
class Features {
  String? place_name;

  Features({this.place_name});
  factory Features.fromJson(Map<String, dynamic> json) {
    return _$FeaturesFromJson(json);
  }
  Map<String, dynamic> toJson() => _$FeaturesToJson(this);
}
