import 'package:agendamento_covid19/failures/failure.dart';

import './failure.dart';

class InvalidCPFFailure extends Failure {
  const InvalidCPFFailure() : super('Formato do CPF inválido!');
}

class DuplicateCPFFailure extends Failure {
  const DuplicateCPFFailure()
      : super('Já existe um usuário com esse CPF no banco de dados!');
}
