import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymoda/pages/shop/payment_canceled.dart';
import 'package:mymoda/pages/shop/payment_declined.dart';
import 'package:mymoda/pages/shop/success.dart';
import 'package:mymoda/themes/methods.dart';
import 'package:mymoda/themes/options.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.url});

  final String url;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool showProgess = false;
  double progressPercent = 0;
  String url = '';

  void conditions() {
    if (url == 'https://fashion.betasayt.com/odenis-bas-tutmadi/') {
      Get.close(2);
      Get.to(() => PaymentDeclinedPage());
    } else if (url == 'https://fashion.betasayt.com/sifaris-detallari/') {
      Get.close(2);
      Get.to(() => SuccessPage());
    } else {
      customAlert(
          context,
          Icons.logout,
          'Ödəniş səhifəsindən çıxış edirsiniz. Çıxış etdiyinizdə ödənişdən imtina etmiş olacaqsınız.',
          'Çıxış',
          () {
            Get.close(3);
            Get.to(() => PaymentCanceledPage(), transition: Transition.fade);
          },
          'İmtina et',
          () {
            Get.back();
          });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              showProgess = true;
              progressPercent = progress / 100;
              if (progressPercent == 1.0) {
                showProgess = false;
              }
            });
          },
          onNavigationRequest: (navigation) {
            if (navigation.url != url) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              this.url = url;
            });
            if (url == 'https://fashion.betasayt.com/sifaris-detallari/') {
              Get.close(2);
              Get.to(() => SuccessPage());
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        conditions();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).primaryColor,
            toolbarHeight: 66.0,
            title: Text('Onlayn ödəniş'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  conditions();
                },
                icon: Icon(Icons.close)),
          ),
          body: RoundedBody(
            child: Column(
              children: [
                if (showProgess) ...[
                  LinearProgressIndicator(
                    value: progressPercent,
                    color: Theme.of(context).colorScheme.secondColor,
                    backgroundColor: Colors.white,
                  )
                ],
                Expanded(
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
