import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OnboardingItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;

  const OnboardingItem({
    Key? key,
    required this.title,
    required this.description,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 430),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageAsset,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            )
          ),

          SizedBox(height: 55),

          Text(
            title,
            style: TextStyle(
              fontSize: 35, 
              fontWeight: FontWeight.w700,
              color: CupertinoColors.systemBackground
            ),
          ),

          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.w500,
                color: Colors.grey
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}