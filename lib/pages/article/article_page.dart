import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'article_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';

class ArticlePage extends GetView<ArticleController> {

  final String title;
  final String body;

  ArticlePage({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                this.title,
                style: TextStyle(color: CupertinoColors.systemBackground),
              ),
              backgroundColor: CupertinoColors.systemBackground,
              border: Border(bottom: BorderSide(color: Colors.transparent)),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: Text(
              this.body,
              style: TextStyle(
                color: CupertinoColors.systemBackground, 
                fontSize: 15, 
                fontWeight: FontWeight.w500
              )
            )
          )
        )
      )
    );
  }
}
