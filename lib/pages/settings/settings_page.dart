import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPage extends GetView<SettingsController> {
  final InAppReview inAppReview = InAppReview.instance;

  final Email email = Email(
    body: 'Version: 1.0 (Android)',
    subject: 'Support for Use',
    recipients: ['support@revoo.studio'],
  );

  final privacyPolicyWebController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://revoo.studio/privacy-policy.html'));

  final termsOfUseWebController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://revoo.studio/terms-of-use.html'));
    
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              automaticallyImplyLeading: false,
              largeTitle: Text(
                "Settings",
                style: TextStyle(color: CupertinoColors.systemBackground),
              ),
              backgroundColor: CupertinoColors.systemBackground,
              border: Border(bottom: BorderSide(color: Colors.transparent)),
            ),
          ];
        },
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text("SUPPORT"),
              tiles: [
                SettingsTile(
                  title: Text("Support"),
                  leading: Icon(Icons.mail),
                  onPressed: (BuildContext context) async {
                    await FlutterEmailSender.send(email);
                  },
                ),
                SettingsTile(
                  title: Text("Rate Us"),
                  leading: Icon(Icons.star),
                  onPressed: (BuildContext context) async {
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text("COMPANY"),
              tiles: [
                SettingsTile(
                  title: Text("Privacy Policy"),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WillPopScope(
                          onWillPop: () async {
                            return true;
                          },
                          child: Scaffold(
                            appBar: AppBar(
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              foregroundColor: CupertinoColors.white,
                              title: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            body: WebViewWidget(controller: privacyPolicyWebController),
                          ),
                        )
                      ),
                    );
                  },
                ),
                SettingsTile(
                  title: Text("Terms of Use"),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WillPopScope(
                          onWillPop: () async {
                            return true;
                          },
                          child: Scaffold(
                            appBar: AppBar(
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              foregroundColor: CupertinoColors.white,
                              title: Text(
                                "Terms of Use",
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            body: WebViewWidget(controller: privacyPolicyWebController),
                          ),
                        )
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}
