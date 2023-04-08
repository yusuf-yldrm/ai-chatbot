import 'dart:async';
import 'dart:io';
import 'package:use/components/onboarding_item.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:use/helpers/data_store.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({ super.key });

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {

  // Properties
  var pageController = PageController();

  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  Timer? timer;
  bool loading = false;

  List<OnboardingInfo> get onboardingPages {
    return [
      OnboardingInfo(
        'resources/images/onboarding_items/chatgpt.png',
        'GPT-3',
        'We’ve trained a model called GPT-3 which interacts in a conversational way. The dialogue format makes it possible for GPT-3 to answer followup questions, admit its mistakes, challenge incorrect premises, and reject inappropriate requests. GPT-3 is a sibling model to InstructGPT, which is trained to follow an instruction in a prompt and provide a detailed response.'
      ),
      OnboardingInfo(
        'resources/images/onboarding_items/dalle.png',
        'DALL·E 2',
        'has learned the relationship between images and the text used to describe them. It uses a process called “diffusion,” which starts with a pattern of random dots and gradually alters that pattern towards an image when it recognizes specific aspects of that image.'
      )
    ];
  }

  // View
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: selectedPageIndex,
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingItem(
                  imageAsset: onboardingPages[index].imageAsset,
                  title: onboardingPages[index].title,
                  description: onboardingPages[index].description,
                );
              }
            ),

            Positioned(
              right: 16,
              left: 16,
              bottom: 16,
              height: 65,
              child: ElevatedButton(
                onPressed: () async {
                  if (isLastPage) {
                    finishOnboarding();
                  } else {
                    forwardAction();
                  }
                },
                child: 
                  loading 
                    ? CupertinoActivityIndicator(color: Colors.black) 
                    : Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      )
                  ),
                    
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Methods

  void startTimer() {
    timer = Timer(Duration(seconds: 5), () {
      setState(() async {
        await finishOnboarding();

        loading = false;
        timer?.cancel();
      });
    });
  }

  Future<void> finishOnboarding() async {
    DataStore dataStore = Provider.of<DataStore>(context, listen: false);
    await dataStore.finishOnboarding();

    Get.toNamed(AppRoutes.BottomBar);
  }

  forwardAction() {
    pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
  }
}

class OnboardingInfo {
  final imageAsset;
  final title;
  final description;

  OnboardingInfo(this.imageAsset, this.title, this.description);
}