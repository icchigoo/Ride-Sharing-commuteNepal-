

class PersonalInfo{
  String? legal_firstname;
  String? legal_lastname;
  DateTime? dob;
  String? address;
  String? profile_pic;
  
  PersonalInfo({
    this.legal_firstname,
    this.legal_lastname,
    this.dob,
    this.address,
    this.profile_pic,
  });

  Map<String, dynamic> toJson() => {
    'legal_firstname': legal_firstname,
    'legal_lastname': legal_lastname,
    'dob': dob,
    'address': address,
    'profile_pic': profile_pic,
  };
}