import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key, required this.onPressed}) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sucesso'),
      content: Text('Operação realizada com sucesso!'),
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Continuar'),
        )
      ],
    );
  }
}

class FailureDialog extends StatelessWidget {
  const FailureDialog(
      {Key? key, required this.onPressed, required this.message})
      : super(key: key);

  final String message;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      title: Text('Fracasso'),
      content: Text(message),
      actions: [
        // IconButton(onPressed: onPressed, icon: Icon(Icons.check))
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Continuar',
            style: TextStyle(fontSize: 18.0),
          ),
        )
      ],
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {Key? key,
      required this.message,
      required this.onConfirm,
      required this.onCancel,
      required this.title})
      : super(key: key);

  final String title;
  final String message;
  final Function() onConfirm;
  final Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: onCancel,
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: onConfirm,
          child: Text(
            'Confirmar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
