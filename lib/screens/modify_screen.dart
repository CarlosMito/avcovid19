import 'package:agendamento_covid19/controllers/sign_up_controller.dart';
import 'package:agendamento_covid19/customs/radio_icon_button.dart';
import 'package:agendamento_covid19/controllers/validators.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifyScreen extends StatefulWidget {
  const ModifyScreen({Key? key}) : super(key: key);

  @override
  _ModifyScreenState createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  final controller = Get.find<SignUpController>();

  final _genderNotifier = ValueNotifier<String>('');
  final List<dynamic> _genders = [
    ['Masculino', Icon(Icons.male)],
    ['Feminino', Icon(Icons.female)],
    ['Outro', Icon(Icons.transgender)],
  ];

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> fields = {};

  @override
  void initState() {
    super.initState();

    _genderNotifier.value = controller.user.gender;
    fields = controller.user.toJson();
  }

  @override
  void dispose() {
    _genderNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  String _formatCPF(String cpf) {
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf[9]}${cpf[10]}';
  }

  String? _formatPhone(String? p) {
    if (p == null) return null;

    return '(${p[0]}${p[1]}) ${p.substring(2, 7)}-${p.substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alterar Cadastro')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: EdgeInsets.all(16.0),
              addAutomaticKeepAlives: true,
              children: [
                TextFormField(
                  initialValue: controller.user.name,
                  onChanged: (text) => fields['name'] = text,
                  validator: mandatoryField,
                  decoration: InputDecoration(
                      hintText: 'Nome Completo',
                      prefixIcon: Icon(
                        Icons.person,
                        size: 20,
                      )),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  enabled: false,
                  initialValue: _formatCPF(controller.user.cpf),
                  inputFormatters: [TextInputMask(mask: '999.999.999-99')],
                  keyboardType: TextInputType.number,
                  validator: validateCPF,
                  onChanged: (text) => fields['cpf'] = text,
                  decoration: InputDecoration(
                      hintText: 'CPF',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 20,
                      )),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: controller.user.age.toString(),
                  onChanged: (text) => fields['age'] = text,
                  inputFormatters: [TextInputMask(mask: '999')],
                  validator: mandatoryField,
                  decoration: InputDecoration(
                      hintText: 'Idade',
                      prefixIcon: Icon(
                        Icons.cake,
                        size: 20,
                      )),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) => fields['email'] = text,
                  validator: validateEmail,
                  initialValue: controller.user.email,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        size: 20,
                      )),
                ),
                const SizedBox(height: 14.0),
                ValueListenableBuilder<String>(
                    valueListenable: _genderNotifier,
                    builder: (context, value, child) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < _genders.length; i++)
                              Container(
                                child: RadioIconButton(
                                  value: _genders[i][0],
                                  groupValue: value,
                                  onChanged: () {
                                    _genderNotifier.value = _genders[i][0];
                                    fields['gender'] = _genders[i][0];
                                  },
                                  icon: _genders[i][1],
                                  label: _genders[i][0],
                                  color: Colors.teal,
                                ),
                              )
                          ],
                        ),
                      );
                    }),
                const SizedBox(height: 12.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  initialValue: _formatPhone(controller.user.phone),
                  inputFormatters: [TextInputMask(mask: '(99) 99999-9999')],
                  onChanged: (text) => fields['phone'] = text,
                  validator: validatePhone,
                  decoration: InputDecoration(
                      hintText: 'Telefone',
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 20,
                      )),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate())
                      controller.modify(fields);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Atualizar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
