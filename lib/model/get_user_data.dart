class getUserData {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  getUserData({this.uuid, this.firstName, this.lastName, this.email});

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
    };
  }

  static getUserData fromJson(Map<String, dynamic> json) {
    return getUserData(
      uuid: json['uuid'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
    );
  }
}
