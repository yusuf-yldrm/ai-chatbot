import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:use/components/message_cell.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/helpers/message_store.dart';
import 'package:use/helpers/remote_config_service.dart';
import 'package:use/models/gptmodel.dart';
import 'package:use/models/message.dart';
import 'package:use/networking/message_service.dart';
import 'package:use/pages/paywall/paywall_page.dart';

class ChatPage extends StatefulWidget {

  final String title;
  final GPTModel model;

  const ChatPage({
    super.key, 
    required this.title,
    required this.model
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {

  // Properties

  var textFieldText = "";
  var texting = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  // Initialization

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final dataStore = Provider.of<DataStore>(context, listen: false);

    if (dataStore.messages.where((element) => element.model == widget.model.name).isEmpty) {
      if (widget.model.name == "text-ada-001" && !dataStore.inReview && !dataStore.hasPermission) {
        final firstMessage = Message(
          model: widget.model.name,
          message: "Ada is the simplest model of GPT-3.\nTherefore, it doesn't offer chatting.\nYou can switch to pro membership for more advanced models.",
          isGPT: true,
          showPremiumTag: true,
          createdAt: DateTime.now()
        );

        MessageDatabase.instance.create(firstMessage);

        setState(() {
          Provider.of<DataStore>(context, listen: false).messages.add(firstMessage);
        });
      } else {
        final firstMessage = Message(
          model: widget.model.name,
          message: "I’m your personal AI\ncompanion. You can talk\nto me about anything\nthat’s on your mind.",
          isGPT: true,
          showPremiumTag: false,
          createdAt: DateTime.now()
        );

        MessageDatabase.instance.create(firstMessage);

        setState(() {
          Provider.of<DataStore>(context, listen: false).messages.add(firstMessage);
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    
    // Called when the keyboard is shown or hidden
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      // Keyboard is shown, perform action here
      scrollDown();
    } else {
      // Keyboard is hidden, perform action here
    }
  }

  // View

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600
          )
        ),
      ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 100),
                itemCount: dataStore.messages.where((element) => element.model == widget.model.name).length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final messages = dataStore.messages.where((element) => element.model == widget.model.name).toList();
                  final messageCount = dataStore.messages.where((element) => element.model == widget.model.name).length;
                  return Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10), 
                    child: MessageCell(message: messages[messageCount - index - 1])
                  );
                }
              ),
            ),
  
            GestureDetector(
              onTap: () {
                scrollDown();
              },
              child: Column(children: [
                Spacer(),
                    
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: 100,
                    child: Container(
                      color: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth - 100,
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: CupertinoColors.systemGrey5,
                                  hintText: 'Type your message here...'
                                ),
                                onChanged: (value) {
                                  textFieldText = value;
                                  scrollDown();
                                },
                                onTap: () {
                                  scrollDown();
                                },
                                onSubmitted: (value) {
                                  textFieldText = value;
                                  scrollDown();
                                },
                              ),
                            ),
            
                            SizedBox(width: 16),
                
                            ClipOval(
                              child: Container(
                                width: 50,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (textController.text.isEmpty) return;
                                    
                                    final messageLimit = RemoteConfigService().messageLimit;
                                    final messagesFromUserCount = dataStore.messages.where((element) => element.model == widget.model.name && element.isGPT == false).length;

                                    if (!dataStore.inReview && messagesFromUserCount >= messageLimit && !dataStore.hasPermission && !RemoteConfigService().isFree) {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => PaywallPage(paywall: dataStore.standardPaywall),
                                        ),
                                      );

                                      return;
                                    }
  
                                    final newMessage = Message( 
                                      model: widget.model.name, 
                                      message: textFieldText, 
                                      isGPT: false, 
                                      showPremiumTag: false,
                                      createdAt: DateTime.now()
                                    );
                                    MessageDatabase.instance.create(newMessage);
  
                                    setState(() {
                                      dataStore.messages.add(newMessage);
                                      texting = true;
                                    });

                                    scrollDown();
            
                                    try {
                                      final input = textController.text;
  
                                      setState(() {
                                        textController.text = "";
                                      });
  
                                      final String text = await MessageService.sendMessage(
                                        input,
                                        widget.model.name,
                                        widget.model.maxTokens,
                                        widget.model.temperature,
                                        widget.model.topP,
                                        widget.model.presencePenalty,
                                        widget.model.frequencyPenalty,
                                        widget.model.bestOf
                                      );
            
                                      if (widget.model.name == "text-ada-001" || widget.model.name == "text-babbage-001") {
                                        final message = text.trim();
                                        final newMessage = Message(
                                          model: widget.model.name, 
                                          message: message,
                                          isGPT: true,
                                          showPremiumTag: false,
                                          createdAt: DateTime.now()
                                        );
                                        MessageDatabase.instance.create(newMessage);
  
                                        setState(() {
                                          dataStore.messages.add(newMessage);
                                        });
                                      } else {
                                        final message = text.trim();
                                        final firstWord = message.split(" ")[0];
                                        final modifiedSentence = message.replaceFirst(firstWord, "");

                                        final newMessage = Message(
                                          model: widget.model.name,
                                          message: modifiedSentence, 
                                          isGPT: true, 
                                          showPremiumTag: false,
                                          createdAt: DateTime.now()
                                        );

                                        MessageDatabase.instance.create(newMessage);

                                        setState(() {
                                          dataStore.messages.add(newMessage);
                                        });
                                      }
            
                                      scrollDown();
                                      if (RemoteConfigService().messageCountsForRating.contains(messagesFromUserCount)) {
                                        showRatingDialog(context);
                                      }
                                    } catch (e) {
                                      setState(() {
                                        texting = false;
                                      });
            
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Something went wrong."),
                                            content: Text(e.toString()),
                                          )
                                      );
                                    } finally {
                                      setState(() {
                                        texting = false;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    CupertinoIcons.paperplane,
                                    color: Colors.black, 
                                    size: 20,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: CircleBorder()
                                  )
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ),
                  );
                })
              ]),
            ),
          ],
        )
      ),
    ); 
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  void showRatingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Container(
          child: Column(
            children: [
              const Text(
                'Are you happy with experience?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFB4B4B7),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '😡',
                  style: TextStyle(fontSize: 45),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '😐',
                  style: TextStyle(fontSize: 45),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }

                  Navigator.of(context).pop();
                },
                child: Text(
                  '😍',
                  style: TextStyle(fontSize: 45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Methods
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut
    );
  }
}