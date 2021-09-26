import 'package:agendamento_covid19/controllers/sign_in_controller.dart';
import 'package:agendamento_covid19/controllers/validators.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _passwordVisibilityNotifier = ValueNotifier<bool>(true);

  final _formKey = GlobalKey<FormState>();

  Map<String, String> fields = {};

  @override
  void dispose() {
    _passwordVisibilityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignInController>();

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // const Spacer(),
            Text(
              'LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 4.0,
              ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Form(
                key: _formKey,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: validateCPF,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          TextInputMask(mask: '999.999.999-99')
                        ],
                        onChanged: (text) => fields['cpf'] = text,
                        decoration: InputDecoration(
                          hintText: 'CPF',
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      ValueListenableBuilder<bool>(
                          valueListenable: _passwordVisibilityNotifier,
                          builder: (context, value, child) {
                            return TextFormField(
                              validator: validatePassword,
                              obscureText: value,
                              onChanged: (text) => fields['password'] = text,
                              decoration: InputDecoration(
                                  hintText: 'Senha',
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      _passwordVisibilityNotifier.value =
                                          !value;
                                    },
                                  )),
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Não possui uma conta?',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed('/sign_up'),
                            child: Text(
                              'Cadastre-se',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate())
                                controller.signIn(fields);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'ENTRAR',
                                style: TextStyle(letterSpacing: 2.6),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
