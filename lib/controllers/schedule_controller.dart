import 'package:agendamento_covid19/customs/result_dialogs.dart';
import 'package:agendamento_covid19/databases/custom_database.dart';
import 'package:agendamento_covid19/failures/failure.dart';
import 'package:agendamento_covid19/models/schedule.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final args = Get.arguments;

  void schedule(fields) async {
    fields['cep'] = fields['cep'].replaceAll('-', '');
    fields['user_cpf'] = args[0];

    Failure? result = await CustomDatabase.instance.insertSchedule(fields);

    if (result == null) {
      Get.dialog(SuccessDialog(onPressed: () {
        args[1].add(Schedule.fromJson(fields));
        Get.back();
        Get.back();
      }));
    } else {
      Get.dialog(
        FailureDialog(
          message: result.message,
          onPressed: () {
            Get.back();
          },
        ),
      );
    }
  }
}
