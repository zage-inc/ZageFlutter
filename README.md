This package makes integrating with Zage a breeze.
All you need is an API key and a payment token and you can start accepting payments with Zage.

## Features
- Run payments for your users directly with Zage
- Display an informational modal about Zage to help your customers understand how ACH works. 

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started
In order to use this package, you need an existing sandbox account with Zage.
Please contact us to get started.

Once you have a public key, you just need to generate a payment token to get started

Then, simply import 'package:zage_flutter/zage.dart', instantiate a Zage object with your public key, and you're ready.

## Usage

Below is a working example (it can also be found in the /example folder).
All you need to do is enter your public key and include a payment token associated with your account.

When you created your payment token, you included a webhook to handle payment success.
Your webhook's response is echoed back as the argument of the onSuccess callback.

The onExit callback will be called if the user exits the payment flow early for any reason.

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      primarySwatch: Colors.green,
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
```

## Additional information
If you have any issues using this package, please contact us. We're eager to help!
