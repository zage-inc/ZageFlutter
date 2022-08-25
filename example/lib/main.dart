import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zage_flutter/zage.dart';

// TODO: Update the publicKey, paymentToken, and callback handlers to your needs
const zage = const Zage(publicKey: 'fill-me-in');
const String paymentToken = 'fill-me-in-too';
void Function(Object) onSuccess = (Object response) => {
  print(response)
};
void Function() onExit = () => {
  print('exited from payment flow')
};

void main() {
  runApp(MaterialApp(
    title: 'Zage Example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      dialogBackgroundColor: Colors.black12,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Run Payment'),
              onPressed: () {
                zage.showZagePayments(context, paymentToken, onSuccess, onExit);
              },
            ),
            ElevatedButton(
              child: const Text('Information Modal'),
              onPressed: () {
                zage.showZageInfoModal(context);
              },
            ),
          ]
        )
      )
    );
  }
}
