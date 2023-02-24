class SupportingDoc {
  String? licence_number;
  String? licence_front;
  String? licence_back;
  String? billbook1;
  String? billbook2;
  String? billbook3;
  String? billbook4;
  SupportingDoc({
    this.licence_number,
    this.licence_front,
    this.licence_back,
    this.billbook1,
    this.billbook2,
    this.billbook3,
    this.billbook4,
  });

  Map<String, dynamic> toJson() => {
    'licence_number': licence_number,
    'licence_front': licence_front,
    'licence_back': licence_back,
    'billbook1': billbook1,
    'billbook2': billbook2,
    'billbook3': billbook3,
    'billbook4': billbook4,
  };

}
