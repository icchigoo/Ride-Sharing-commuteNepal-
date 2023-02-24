import 'package:commute_nepal/model/personal_info.dart';
import 'package:commute_nepal/model/supporting_doc.dart';
import 'package:commute_nepal/model/vehicle_info.dart';

class Verification {
  PersonalInfo? personalInfo;
  VehicleInfo? vehicleInfo;
  SupportingDoc? supportingDoc;
  Verification({
    this.personalInfo,
    this.vehicleInfo,
    this.supportingDoc,
  });
}
