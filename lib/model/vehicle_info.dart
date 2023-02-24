import 'dart:ffi';

class VehicleInfo {
  String? brand;
  String? model_number;
  String? color;
  String? plate_number;
  String? vehicle_pic;

  VehicleInfo({
    this.brand,
    this.model_number,
    this.color,
    this.plate_number,
    this.vehicle_pic,
  });

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'model_number': model_number,
    'color': color,
    'plate_number': plate_number,
    'vehicle_pic': vehicle_pic,
  };
}
