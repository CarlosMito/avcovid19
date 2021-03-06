import 'package:agendamento_covid19/controllers/sign_up_controller.dart';
import 'package:agendamento_covid19/widgets/radio_icon_button.dart';
import 'package:agendamento_covid19/controllers/validators.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isHidden = true;

  final _genderNotifier = ValueNotifier<String>('');
  final List<dynamic> _genders = [
    ['Masculino', Icon(Icons.male)],
    ['Feminino', Icon(Icons.female)],
    ['Outro', Icon(Icons.transgender)],
  ];

  final controller = Get.find<SignUpController>();

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> fields = {};

  @override
  void dispose() {
    _genderNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Usuário')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: EdgeInsets.all(16.0),
              addAutomaticKeepAlives: true,
              children: [
                // Incluir widget para colocar uma foto
                // Incluir widget para colocar uma foto
                // Incluir widget para colocar uma foto
                // Incluir widget para colocar uma foto
                // Incluir widget para colocar uma foto
                // Incluir widget para colocar uma foto
                TextFormField(
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
                TextFormField(
                  onChanged: (text) => fields['password'] = text,
                  obscureText: _isHidden,
                  validator: validatePassword,
                  decoration: InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          icon: Icon(_isHidden
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate())
                      controller.signUp(fields);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Cadastrar'),
                  ),
                ),
                // const SizedBox(height: 12.0),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.createUsersTable();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('CREATE USERS TABLE'),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.deleteUsersTable();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('DROP USERS TABLE'),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.getAllUsers();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('GET ALL USERS TABLE'),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
