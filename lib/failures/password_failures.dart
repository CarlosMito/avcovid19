import 'package:agendamento_covid19/failures/failure.dart';

import './failure.dart';

class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure() : super('Senha inválida!');
}
