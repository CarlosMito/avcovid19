import 'package:agendamento_covid19/models/schedule.dart';
import 'package:flutter/material.dart';

class ScheduleDisplayer extends StatelessWidget {
  const ScheduleDisplayer(
      {Key? key, required this.schedule, required this.deleteFunction})
      : super(key: key);

  final Schedule schedule;
  final Function() deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 160,
            child: Column(
              children: [
                SizedBox(
                  height: 36.0,
                  width: 100,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      schedule.date,
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          child: Text(
                            schedule.time,
                            style: TextStyle(
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(schedule.cep.substring(0, 5) +
                              '-' +
                              schedule.cep.substring(5)),
                        ),
                        IconButton(
                          onPressed: () => deleteFunction(),
                          icon: Icon(Icons.delete, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
