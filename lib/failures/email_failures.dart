import 'package:agendamento_covid19/failures/failure.dart';

import './failure.dart';

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Email inválido');
}
