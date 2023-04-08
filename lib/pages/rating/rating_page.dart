import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'rating_controller.dart';

class RatingPage extends GetView<RatingController> {

  // View

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(children: [
            Spacer(),

            Text(
              "Love the App?",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
      
            SizedBox(height: 35),
      
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 65,
              child: ElevatedButton(
                onPressed: () async {
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }

                  Navigator.of(context).pop();
                },
                child: Text(
                  "Yes, I love it 😍",
                  style: TextStyle(
                    color: CupertinoColors.label,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  )
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupertinoColors.systemBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text(
                "No, I don’t",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent
              ),
            ),

            Spacer(),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage('resources/images/rating_cover.png'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
