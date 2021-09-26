import 'package:agendamento_covid19/databases/custom_database.dart';
import 'package:agendamento_covid19/models/schedule.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final user = Get.arguments;

  List<Schedule> schedules = [];

  Future<List<Schedule>> loadSchedules() async {
    try {
      schedules = await CustomDatabase.instance.retrieveSchedules(user.cpf);
    } catch (e) {}
    // schedules.forEach((s) => print('${s.cep} at ${s.st}'));
    return schedules;
  }
}
