class UserRegisterModel {
  final String name;
  final String lastname;
  final String email;
  final String password;
  final int documenttype;
  final String documentnumber;
  final String phonenumber;

  UserRegisterModel({
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    required this.documenttype,
    required this.documentnumber,
    required this.phonenumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
      'documenttype': documenttype,
      'documentnumber': documentnumber,
      'phonenumber': phonenumber,
    };
  }
}
