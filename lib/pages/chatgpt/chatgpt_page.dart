import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/helpers/remote_config_service.dart';
import 'package:use/models/gptmodel.dart';
import 'package:use/pages/paywall/paywall_page.dart';
import 'chatgpt_controller.dart';
import 'package:use/pages/chat/chat_page.dart';
import '/components/model_category_view.dart';

class ChatGPTPage extends StatefulWidget {

  const ChatGPTPage({super.key});

  @override
  State<ChatGPTPage> createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  
  // Life Cycle 

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Future.delayed(Duration(seconds: 1));

    final dataStore = Provider.of<DataStore>(context, listen: false);
    if (!dataStore.hasPermission && !dataStore.inReview && !RemoteConfigService().isFree) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => PaywallPage(paywall: dataStore.standardPaywall),
        ),
      );
    }
  }

  // View

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemBackground,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CupertinoSliverNavigationBar(
                automaticallyImplyLeading: false,
                trailing: (!dataStore.hasPermission && !RemoteConfigService().isFree) ? ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => PaywallPage(paywall: dataStore.standardPaywall),
                      ),
                    ),
                  },
                  child: Text(
                    "PRO",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ) : null,
                largeTitle: Text(
                  "GPT-3",
                  style: TextStyle(color: CupertinoColors.systemBackground),
                ),
                backgroundColor: CupertinoColors.systemBackground,
                border: Border(bottom: BorderSide(color: Colors.transparent)),
              ),
            ];
          },
          body: ListView.builder(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 100),
              itemCount: RemoteConfigService().models.length,
              itemBuilder: (context, index) {
                var item = RemoteConfigService().models[index];
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ModelCategoryView(
                    icon: "resources/images/models/${item.title.toLowerCase()}.png", 
                    title: item.title,
                    description: item.description,
                    canAccess: (dataStore.hasPermission || !item.isPremium) || RemoteConfigService().isFree,
                    onPressed: () {
                      if ((dataStore.hasPermission || !item.isPremium) || RemoteConfigService().isFree) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              title: item.title,
                              model: item,
                            )
                          )
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => PaywallPage(paywall: dataStore.standardPaywall),
                          ),
                        );
                      }
                    }
                  ),
                );
              }
          )
        ),
      ),
    );
  }
}
