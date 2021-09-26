import 'package:agendamento_covid19/failures/failure.dart';

class EmptyGenderFailure extends Failure {
  const EmptyGenderFailure() : super('O campo do gênero não pode estar vazio!');
}
