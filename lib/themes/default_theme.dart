// import 'package:flutter/material.dart';

// const _inputBorder = OutlineInputBorder(
//   // borderRadius: BorderRadius.all(Radius.circular(12)),
//   borderSide: BorderSide(width: 1, color: Colors.grey),
// );

// final lightTheme = ThemeData(
//     primaryColor: Colors.teal,
//     // brightness: Brightness.light,
//     appBarTheme: AppBarTheme(
//       // backgroundColor: Colors.teal,
//       centerTitle: true,
//       elevation: 2,
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     // elevatedButtonTheme: ElevatedButtonThemeData(
//     //     style: ButtonStyle(
//     //         // backgroundColor: MaterialStateProperty.all(Color(0xff0068FF)),
//     //         shape: MaterialStateProperty.all(const RoundedRectangleBorder(
//     //             borderRadius: BorderRadius.all(Radius.circular(10)))))),
//     // buttonColor: Colors.green,
//     inputDecorationTheme: InputDecorationTheme(
//         // hoverColor: Colors.transparent,
//         // focusedBorder: _inputBorder,
//         // border: _inputBorder,
//         // enabledBorder: _inputBorder,
//         // fillColor: Color(0xffececec),
//         // filled: true,
//         ));

import 'package:flutter/material.dart';

// const _inputBorder = OutlineInputBorder(
//   // borderRadius: BorderRadius.all(Radius.circular(12)),
//   borderSide: BorderSide(width: 1, color: Colors.grey),
// );

final lightTheme = ThemeData(
  primaryColor: Colors.teal,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Colors.grey,
      ),
    ),
  ),
);
