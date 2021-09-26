class User {
  late final String cpf;
  late int age;
  late String gender;
  late String name;
  late String? email;
  late String? phone;

  User.fromJson(Map json) {
    cpf = json['cpf'];
    age = json['age'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() => {
        'cpf': cpf,
        'age': age,
        'gender': gender,
        'name': name,
        'email': email,
        'phone': phone
      };

  // For DateTime objects you can use .toIso8601String() method.
}
