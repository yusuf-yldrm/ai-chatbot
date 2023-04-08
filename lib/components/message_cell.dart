import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/helpers/remote_config_service.dart';
import 'package:use/models/message.dart';
import 'package:use/pages/paywall/paywall_page.dart';

class MessageCell extends StatelessWidget {

  // Properties

  final Message message;

  // Initialization

  const MessageCell({
    Key? key, 
    required this.message,
  }) : super(key: key);

  // View

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(children: [
              !message.isGPT ? Spacer() : Container(),
          
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                  color: message.isGPT ? ColorConstants.messageBackground : CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(message.isGPT ? 10 : 5),
                    topLeft: Radius.circular(message.isGPT ? 5 : 10),
                    bottomRight: Radius.circular(message.isGPT ? 10 : 5),
                    bottomLeft: Radius.circular(message.isGPT ? 5 : 10)
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(children: [
                    SelectableText(
                      message.message,
                      maxLines: null,
                      style: TextStyle(
                        color: message.isGPT ? CupertinoColors.systemBackground : CupertinoColors.label,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
  
                    message.showPremiumTag && !dataStore.hasPermission && !RemoteConfigService().isFree 
                      ?
                        Column(children: [
                          SizedBox(height: 10),
  
                          Row(children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => PaywallPage(paywall: dataStore.standardPaywall),
                                  ),
                                );
                              },
                              child: Text(
                                "Go PRO",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                ),
                              )
                            ),
                        
                            Spacer(),
                          ]),
                        ]) 
                      : 
                        SizedBox()
                  ])
                ),
              ),
          
              message.isGPT ? Spacer() : Container(),
            ]),
        ])
      ),
    );
  }
}

 class ColorConstants {
  static const messageBackground = Color.fromARGB(255, 40, 40, 40);
}