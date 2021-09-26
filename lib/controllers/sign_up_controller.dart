import 'package:agendamento_covid19/widgets/result_dialogs.dart';
import 'package:agendamento_covid19/databases/custom_database.dart';
import 'package:agendamento_covid19/failures/failure.dart';
import 'package:agendamento_covid19/models/user.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final user = Get.arguments;

  void signUp(Map<String, dynamic> fields) async {
    fields.removeWhere((key, value) => value == null || value == '');

    for (String key in ['cpf', 'phone'])
      if (fields.containsKey(key))
        fields[key] = fields[key].replaceAll(RegExp(r'[^0-9]'), '');

    Failure? result = await CustomDatabase.instance.insertUser(fields);

    if (result == null) {
      Get.dialog(SuccessDialog(onPressed: () {
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

  void modify(Map<String, dynamic> fields) async {
    fields.removeWhere((key, value) => value == null || value == '');

    for (String key in ['cpf', 'phone'])
      if (fields.containsKey(key))
        fields[key] = fields[key].replaceAll(RegExp(r'[^0-9]'), '');

    Failure? result = await CustomDatabase.instance.updateUser(fields);

    if (result == null) {
      Get.dialog(SuccessDialog(onPressed: () {
        user.name = fields['name'];

        user.age =
            fields['age'] is String ? int.parse(fields['age']) : fields['age'];

        user.gender = fields['gender'];
        user.email = fields['email'] == '' ? null : fields['email'];
        user.phone = fields['phone'] == '' ? null : fields['phone'];

        Get.back();
        Get.back(result: user);
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

  Future<User?> testeRetrieve() async {
    // return await UsersDatabase.instance.retrieve('47510896843');
  }
}
