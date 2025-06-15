import 'dart:convert';

import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constant.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String? url;
  final String? accessToken;

  PaymentWebViewScreen({required this.url, this.accessToken});

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController controller;

  bool isInvoiceNumberFound = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = WebViewController();
    controller.loadRequest(Uri.parse('$SADAD_PAY_URL/${widget.url}'));
    controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        log('Start: $url');
      },
      onPageFinished: (url) {
        log('End: $url');
        if (url.contains('https://sadadqa.com/invoicedetail')) getHtmlBody(url);
      },
      onProgress: (progress) {
        //
      },
      onNavigationRequest: (request) {
        return NavigationDecision.navigate;
      },
    ));

    log('URL: $SADAD_API_URL/${widget.url}');
  }

  void getHtmlBody(String url) {
    get(Uri.parse(url)).then((value) {
      log(value.body);

      String txnId = parseHtmlString(value.body).removeAllWhiteSpace().splitBetween('TransactionNo:', 'InvoiceInformation').trim();

      if (txnId.isNotEmpty && txnId.startsWith('#SD')) {
        isInvoiceNumberFound = true;

        getSingleTrans(txnId.validate().replaceAll('#', ''));
      } else {
        toast(language.lblInvalidTransaction);
      }
    }).catchError(onError);
  }

  Future<void> getSingleTrans(String? txnId) async {
    var request = Request(
      'GET',
      Uri.parse('$SADAD_API_URL/api/transactions/getTransaction'),
    )..headers.addAll(buildHeaderForSadad(sadadToken: widget.accessToken.validate()));
    var params = {
      "transactionno": txnId,
    };
    request.body = jsonEncode(params);

    log(request.url);
    log(request.body);

    appStore.setLoading(true);
    StreamedResponse response = await request.send();
    appStore.setLoading(false);

    print(response.statusCode);

    if (response.statusCode.isSuccessful()) {
      String body = await response.stream.bytesToString();
      Map res = jsonDecode(body);

      if (res['invoice']['invoicestatus']['name'] == 'Paid') {
        finish(context, txnId.validate());
      } else {
        finish(context, '');
      }
    } else {
      toast(errorSomethingWentWrong);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.payment,
        color: context.primaryColor,
        textColor: Colors.white,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
      ),
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
