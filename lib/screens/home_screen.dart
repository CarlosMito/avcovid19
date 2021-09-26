import 'package:agendamento_covid19/controllers/home_controller.dart';
import 'package:agendamento_covid19/customs/result_dialogs.dart';
import 'package:agendamento_covid19/customs/schedule_displayer.dart';
import 'package:agendamento_covid19/databases/custom_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento de Vacinas'),
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(ConfirmDialog(
                    message: 'Tem certeza que deseja sair?',
                    onConfirm: () {
                      Get.back();
                      Get.offNamed('./sign_in');
                    },
                    onCancel: () => Get.back(),
                    title: 'Logout'));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    'Nome: ' + controller.user.name,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 6.0),
                  Text('CPF: ' + controller.user.cpf),
                  const SizedBox(height: 6.0),
                  Text('Email ' + (controller.user.email ?? '')),
                  const SizedBox(height: 6.0),
                  Text('Gênero: ' + controller.user.gender),
                  const SizedBox(height: 6.0),
                  Text('Telefone: ' + (controller.user.phone ?? '')),
                ],
              ),
            ),
            FutureBuilder(
              future: controller.loadSchedules(),
              initialData: [],
              builder: (context, snapshot) {
                return SizedBox(
                  height: 200.0,
                  // padding: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.schedules.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return ScheduleDisplayer(
                            schedule: controller.schedules[index],
                            deleteFunction: () {
                              Get.dialog(ConfirmDialog(
                                  message:
                                      'Tem certeza? A remoção não poderá ser revertida!',
                                  onConfirm: () {
                                    CustomDatabase.instance.delete(
                                        controller.schedules[index].id!);

                                    setState(() {
                                      controller.schedules.removeAt(index);
                                    });
                                    Get.back();
                                  },
                                  onCancel: () => Get.back(),
                                  title: 'Cancelar Agendamento'));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await Get.toNamed('./modify', arguments: controller.user);

                setState(() {});
              },
              child: Text('Alterar Dados do Usuário'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Get.toNamed('./schedule',
                    arguments: [controller.user.cpf, controller.schedules]);

                setState(() {});
              },
              child: Text('Novo Agendamento'),
            ),
          ],
        ),
      ),
    );
  }
}
