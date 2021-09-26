String? mandatoryField(String? entry) {
  if (entry == null || entry.isEmpty) return 'Esse campo é obrigatório!';

  return null;
}

String? validateCPF(String? cpf) {
  String? result = mandatoryField(cpf);
  if (result != null) return result;

  cpf = cpf!.replaceAll(RegExp(r'[^0-9]'), '');

  // // Os 11 dígitos não podem ser todos iguais entre si
  if (cpf.length != 11 || cpf.replaceAll(cpf[0], '').isEmpty)
    return 'Esse não é um CPF válido!';

  for (int j = 0; j < 2; j++) {
    int total = 0;

    for (int i = 0; i < 9 + j; i++) total += int.parse(cpf[i]) * (10 + j - i);

    int verifier = 11 - total % 11;

    // [total % 11] é 1 ou 0
    if (verifier > 9) {
      if (cpf[9 + j] != '0') return 'Esse não é um CPF válido!';
    }

    // [total % 11] não é 1 nem 0
    else if (verifier.toString() != cpf[9 + j])
      return 'Esse não é um CPF válido!';
  }

  return null;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) return null;

  RegExp emailValidator = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  if (!emailValidator.hasMatch(email)) return 'Esse não é um email válido!';

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.length < 6)
    return 'A senha deve conter no mínimo 6 caracteres!';

  return null;
}

String? validatePhone(String? phone) {
  if (phone == null || phone.isEmpty) return null;

  phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

  if (phone.length < 11) return 'Esse não é um número de telefone válido!';

  return null;
}

String? validateCEP(String? cep) {
  String? result = mandatoryField(cep);
  if (result != null) return result;

  cep = cep!.replaceAll(RegExp(r'[^0-9]'), '');

  if (cep.length != 8) return 'A formatação do número está incorreta!';

  return null;
}
