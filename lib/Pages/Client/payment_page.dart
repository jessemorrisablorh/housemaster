import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';

class PaystackPaymentPage extends StatefulWidget {
  final num amount; // in pesewas (e.g. 5000 = GHS 50)
  final String email;
  final String publicKey;

  const PaystackPaymentPage({
    super.key,
    required this.amount,
    required this.email,
    required this.publicKey,
  });

  @override
  State<PaystackPaymentPage> createState() => _PaystackPaymentPageState();
}

class _PaystackPaymentPageState extends State<PaystackPaymentPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final reference = const Uuid().v4();

    final html =
        '''
    <!DOCTYPE html>
    <html>
    <head>
      <script src="https://js.paystack.co/v1/inline.js"></script>
    </head>
    <body onload="payWithPaystack()">
      <script>
        function payWithPaystack(){
          var handler = PaystackPop.setup({
            key: 'pk_test_9e30a1262af4a67a1eaeb849ce1b10475799aa23',
            email: '${widget.email}',
            amount: ${widget.amount},
            currency: "GHS",
            ref: '$reference',
            callback: function(response){
              window.location.href = "https://success.com/?ref=" + response.reference;
            },
            onClose: function(){
              window.location.href = "https://cancel.com";
            }
          });
          handler.openIframe();
        }
      </script>
    </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith("https://success.com/")) {
              final uri = Uri.parse(request.url);
              final ref = uri.queryParameters['ref'] ?? '';
              verifyPayment(ref);
              return NavigationDecision.prevent;
            }

            if (request.url.startsWith("https://cancel.com")) {
              Get.back();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<void> verifyPayment(String reference) async {
    setState(() => isLoading = true);

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'verifyPayment',
      );

      final response = await callable.call({"reference": reference});

      final data = response.data;

      if (data["status"] == "success") {
        setState(() => isLoading = false);

        Get.snackbar("Success", "Payment Successful");

        // 🔥 DO YOUR ORDER CREATION HERE
        // createOrder();

        Get.back(); // close payment page
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", "Payment verification failed");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Verification error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 20.0,
                right: 20.0,
              ),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Container(
                      height: 0.060 * height,
                      width: 0.40 * width,
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(60),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          SlideInRight(
                            duration: Duration(milliseconds: 900),
                            child: Container(
                              height: 0.060 * height,
                              width: 0.14 * width,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Back",
                            style: GoogleFonts.poppins(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
