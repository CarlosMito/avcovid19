import 'package:agendamento_covid19/failures/failure.dart';

class ScheduleConflictFailure extends Failure {
  const ScheduleConflictFailure()
      : super(
            'Já existe um agendamento marcado para esse horário nesse local!');
}
