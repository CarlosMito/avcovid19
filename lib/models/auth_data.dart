import 'package:agendamento_covid19/models/user.dart';

class AuthData {
  late final int id;
  late final String token;
  late final User user;

  AuthData.fromJson(Map json) {
    id = json['id'];
    token = json['token'];
    user = User.fromJson(json['user']);
  }
}
