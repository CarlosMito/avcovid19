import 'dart:async';

import 'package:agendamento_covid19/controllers/schedule_controller.dart';
import 'package:agendamento_covid19/controllers/validators.dart';
import 'package:agendamento_covid19/customs/result_dialogs.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_listview/infinite_listview.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, dynamic> fields = {};

  final _controllers = [InfiniteScrollController(), InfiniteScrollController()];

  final _formKey = GlobalKey<FormState>();

  double containerHeight = 35.0;

  int get hour => (_controllers[0].offset ~/ containerHeight + 1) % 24;
  int get minute => (_controllers[1].offset ~/ containerHeight + 1) * 5 % 60;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timestamp) {
      List<double> lastVelocity = [0, 0];

      for (int i = 0; i < 2; i++) {
        _controllers[i].jumpTo(-containerHeight * 5);

        _controllers[i].animateTo(
          -containerHeight,
          duration: Duration(milliseconds: 1800 - i * 200),
          curve: Curves.elasticOut,
        );

        _controllers[i].addListener(() {
          lastVelocity[i] = _controllers[i].position.activity!.velocity;
        });

        _controllers[i].position.isScrollingNotifier.addListener(() {
          if (!_controllers[i].position.isScrollingNotifier.value) {
            if (lastVelocity[i].abs() < 0.5) {
              int floor = _controllers[i].offset ~/
                  containerHeight *
                  containerHeight.round();

              double targetOffset =
                  _controllers[i].offset - floor < containerHeight / 2
                      ? floor.toDouble()
                      : floor + containerHeight;

              Future.delayed(
                Duration.zero,
                () => {
                  _controllers[i].animateTo(
                    targetOffset,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  )
                },
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controllers[0].dispose();
    _controllers[1].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleController>();

    return Scaffold(
      appBar: AppBar(title: Text('Novo Agendamento')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          constraints: BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2022, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.week,
                  locale: Localizations.localeOf(context).languageCode,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  onFormatChanged: (format) {},
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: Row(
                    children: [
                      Flexible(
                        child: InfiniteListView.builder(
                          controller: _controllers[0],
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                height: containerHeight,
                                child: Text(
                                  (index % 24).toString().padLeft(2, '0'),
                                  style: TextStyle(fontSize: 26.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(':', style: TextStyle(fontSize: 26.0)),
                      Flexible(
                        child: InfiniteListView.builder(
                          controller: _controllers[1],
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                height: containerHeight,
                                child: Text(
                                  "${index % 12 * 5}".padLeft(2, '0'),
                                  style: TextStyle(fontSize: 26.0),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (text) => fields['cep'] = text,
                  inputFormatters: [TextInputMask(mask: '99999-999')],
                  keyboardType: TextInputType.number,
                  validator: validateCEP,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    labelText: 'CEP',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    fields['st'] = hour * 60 + minute;

                    var day = _focusedDay.day.toString().padLeft(2, '0');
                    var month = _focusedDay.month.toString().padLeft(2, '0');

                    fields['sd'] = '${day}/${month}/${_focusedDay.year}';

                    if (_formKey.currentState!.validate()) {
                      String strHour = hour.toString().padLeft(2, '0');
                      String strMinute = minute.toString().padLeft(2, '0');

                      String message =
                          'Data: ${fields['sd']}\nHorário: $strHour:$strMinute\nCEP: ${fields['cep']}\n';

                      var cep = fields['cep'].replaceAll('-', '');
                      String httpRead = '';

                      try {
                        httpRead = await http
                            .read(Uri.parse(
                          "https://viacep.com.br/ws/$cep/json/",
                        ))
                            .timeout(Duration(seconds: 2), onTimeout: () {
                          throw TimeoutException(
                              'O pedido excedeu o tempo limite de conexão!');
                        });
                      } catch (error) {
                        httpRead = '{"erro":true}';
                      }

                      var result = json.decode(httpRead);

                      if (!result.containsKey('erro')) {
                        message +=
                            '${result['logradouro']} - ${result['bairro']} - ${result['localidade']}, ${result['uf']}';
                      }

                      Get.dialog(ConfirmDialog(
                          title: 'Confirmar Agendamento',
                          message: message,
                          onConfirm: () {
                            Get.back();
                            controller.schedule(fields);
                          },
                          onCancel: () {
                            Get.back();
                          }));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Marcar Agendamento'),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.createSchedulesTable();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('CREATE SCHEDULES TABLE'),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.deleteSchedulesTable();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('DROP SCHEDULES TABLE'),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     CustomDatabase.instance.getAllSchedules();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: Text('GET ALL SCHEDULES'),
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
