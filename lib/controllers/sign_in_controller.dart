import 'dart:convert';

import 'package:agendamento_covid19/widgets/result_dialogs.dart';
import 'package:agendamento_covid19/databases/custom_database.dart';
import 'package:agendamento_covid19/failures/failure.dart';
import 'package:agendamento_covid19/models/user.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  // String _cpf = '';
  // String _password = '';

  // set email(String cpf) => _cpf = cpf;
  // set password(String password) => _password = password;

  void signIn(fields) async {
    fields['cpf'] = fields['cpf'].replaceAll(RegExp(r'[^0-9]'), '');

    Either<String, Failure> result =
        await CustomDatabase.instance.retrievePassword(fields['cpf']);

    result.fold(
      (left) async {
        var bytes = utf8.encode(fields['password']);
        var digest = sha1.convert(bytes);

        if (digest.toString() == left) {
          Either<User, Failure> user =
              await CustomDatabase.instance.retrieveUser(fields['cpf']);

          user.fold((l) => Get.offNamed('./home', arguments: l), (r) {});
        } else {
          Get.dialog(
            FailureDialog(
              onPressed: () => Get.back(),
              message: 'CPF ou Senha incorretos!',
            ),
          );
        }
      },
      (right) {
        Get.dialog(
          FailureDialog(
            onPressed: () => Get.back(),
            message: 'CPF ou Senha incorretos!',
          ),
        );
      },
    );
  }
}
