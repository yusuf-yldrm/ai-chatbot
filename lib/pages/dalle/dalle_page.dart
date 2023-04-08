import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/helpers/remote_config_service.dart';
import 'package:use/pages/generator/generator_page.dart';
import 'package:use/pages/paywall/paywall_page.dart';
import 'dalle_controller.dart';

class DallePage extends StatefulWidget {

  const DallePage({super.key});

  @override
  State<DallePage> createState() => DallePageState();
}

class DallePageState extends State<DallePage> {

  List<Widget> items = [];
  String prompt = "";
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();

    for (int i = 0; i < 6; i++) {
      items.add(
        ClipRRect(
          child: Image(image: AssetImage("resources/images/example_images/example_image_" + (i + 1).toString() + ".png")),
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemBackground,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Text(
                    "DALL·E 2",
                    style: TextStyle(color: CupertinoColors.systemBackground),
                  ),
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
                  backgroundColor: CupertinoColors.systemBackground,
                  border: Border(bottom: BorderSide(color: Colors.transparent)),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(children: [
                    Text(
                      "AI system that can create realistic images and art from a description in natural language.",
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
            
                    SizedBox(height: 34),
            
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[900],
                        labelText: 'What do you want to see?',
                      ),
                      onChanged: (value) {
                        prompt = value;
                      },
                    ),
            
                    SizedBox(height: 21),
            
                    ElevatedButton(
                      onPressed: () {
                        if (!dataStore.hasPermission && !RemoteConfigService().isFree) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaywallPage(paywall: dataStore.standardPaywall)
                            )
                          );
                          return;
                        }

                        if (prompt.isEmpty) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GeneratorPage(prompt: prompt)
                          )
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints.expand(height: 65),
                        child: Center(
                          child: Text(
                            dataStore.hasPermission && prompt.isEmpty ? "Write a prompt" : "Turn text into art",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            )
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dataStore.hasPermission && prompt.isEmpty ? Colors.white.withOpacity(0.6) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            
                    SizedBox(height: 44),
            
                    Row(children: [
                      Text(
                        "Examples",
                        style: TextStyle(
                          color: CupertinoColors.systemBackground,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ]),
        
                    SizedBox(height: 21),
        
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 21,
                      crossAxisSpacing: 21,
                      children: items,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}