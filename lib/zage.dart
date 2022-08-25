library zage;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'zage_info_modal.dart';
import 'zage_payments.dart';

class Zage {
  final String publicKey;

  const Zage({
    this.publicKey = ''
  }) : super();

  void showZagePayments(BuildContext context, String paymentToken, onComplete, onExit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            bottom: false,
            child: ZagePayments(publicKey: publicKey, paymentToken: paymentToken, onComplete: onComplete, onExit: onExit)
        );
      },
      useSafeArea: false,
      barrierColor: const Color(0x00000000),
    );
  }

  void showZageInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            bottom: false,
            child: ZageInfoModal(publicKey: publicKey)
        );
      },
      useSafeArea: false,
      barrierColor: const Color(0x00000000),
    );
  }
}