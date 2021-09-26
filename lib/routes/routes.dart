import 'package:agendamento_covid19/controllers/home_controller.dart';
import 'package:agendamento_covid19/controllers/schedule_controller.dart';
import 'package:agendamento_covid19/controllers/sign_up_controller.dart';
import 'package:agendamento_covid19/screens/modify_screen.dart';
import 'package:agendamento_covid19/screens/schedule_screen.dart';
import 'package:agendamento_covid19/screens/sign_up_screen.dart';
import 'package:get/get.dart';
import 'package:agendamento_covid19/screens/sign_in_screen.dart';
import 'package:agendamento_covid19/screens/home_screen.dart';
import 'package:agendamento_covid19/controllers/sign_in_controller.dart';

abstract class Routes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/sign_in',
      page: () => SignInScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignInController());
      }),
    ),
    GetPage(
      name: '/sign_up',
      page: () => SignUpScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignUpController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: '/schedule',
      page: () => ScheduleScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ScheduleController());
      }),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: '/modify',
      page: () => ModifyScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignUpController());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
