import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:esewa/constant/esewa.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';

import 'package:flutter/material.dart';

class Esewa {
  pay() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: kEsewaClientId,
          secretId: kEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: "1000",
          callbackUrl: 'https://uat.esewa.com.np/epay/main',

        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          debugPrint('SUCCESS');
          verify(result);
        },
        onPaymentFailure: () {
          debugPrint('FAILURE');
        },
        onPaymentCancellation: () {
          debugPrint('CANCEL');
        },
      );
    } catch (e) {
      debugPrint('EXCEPTION');
    }
  }

  verify(EsewaPaymentSuccessResult result) async {
    try {
      Dio dio = Dio();
      String basicAuth = 'Basic ${base64.encode(utf8.encode('$kEsewaClientId:$kEsewaSecretKey'))}';
      Response response = await dio.get(
        'https://uat.esewa.com.np/epay/transrec',
        queryParameters: {'txnRefId': result.refId},
        options: Options(
          headers: {'Authorization': basicAuth},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Verification Successful: ${response.data}');
      } else {
        debugPrint('Verification Failed: ${response.data}');
      }
    } catch (e) {
      print(e);
    }
  }
}