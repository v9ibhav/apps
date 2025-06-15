import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String? url;
  final String? accessToken;

  PaymentWebViewScreen({required this.url, this.accessToken});

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  WebViewController controller = WebViewController();
  bool isInvoiceNumberFound = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    log('URL: $SADAD_API_URL/${widget.url}');

    controller.loadRequest(Uri.parse('$SADAD_API_URL/${widget.url}'));
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) {
        log('End: $url');
        if (url.contains('https://sadadqa.com/invoicedetail')) getHtmlBody(url);
      },
    ));
  }

  void getHtmlBody(String url) {
    get(Uri.parse(url)).then((value) {
      log(value.body);

      String txnId = parseHtmlString(value.body).removeAllWhiteSpace().splitBetween('TransactionNo:', 'InvoiceInformation').trim();

      if (txnId.isNotEmpty && txnId.startsWith('#SD')) {
        isInvoiceNumberFound = true;

        getSingleTrans(txnId.validate().replaceAll('#', ''));
      } else {
        toast(languages.lblInvalidTransaction);
      }
    }).catchError(onError);
  }

  Future<void> getSingleTrans(String? txnId) async {
    var request = Request('GET', Uri.parse('$SADAD_API_URL/api/transactions/getTransaction'));

    request.headers.addAll(buildHeaderForSadad(sadadToken: widget.accessToken.validate()));

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
      appBar: appBarWidget(languages.lblPayment, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
