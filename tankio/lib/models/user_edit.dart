class UserEditModel {
  final String name;
  final String lastname;
  final String email;
  final int documenttype;
  final String documentnumber;
  final String phonenumber;

  UserEditModel({
    required this.name,
    required this.lastname,
    required this.email,
    required this.documenttype,
    required this.documentnumber,
    required this.phonenumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'email': email,
      'documenttype': documenttype,
      'documentnumber': documentnumber,
      'phonenumber': phonenumber,
    };
  }
}
