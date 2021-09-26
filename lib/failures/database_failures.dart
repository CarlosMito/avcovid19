import 'package:agendamento_covid19/failures/failure.dart';

class CPFNotFoundFailure extends Failure {
  const CPFNotFoundFailure()
      : super('Não foi encontrado nenhum usuário com esse CPF!');
}
