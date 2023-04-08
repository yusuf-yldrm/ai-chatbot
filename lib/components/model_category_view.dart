import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelCategoryView extends StatelessWidget {

  final String icon;
  final String title;
  final String description;
  final bool canAccess;
  final VoidCallback? onPressed;

  const ModelCategoryView({
    Key? key, 
    required this.icon,
    required this.title, 
    required this.description,
    required this.canAccess,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Container(
        constraints: BoxConstraints.expand(height: 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(this.icon), 
              width: 50, 
              height: 50, 
              fit: BoxFit.cover
            ),
      
            SizedBox(width: 20),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.w700,
                    color: CupertinoColors.systemBackground
                  ),
                ),
      
                Text(
                  this.description,
                  style: TextStyle(
                    fontSize: 17, 
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                  ),
                ),

                Spacer(),
              ],
            ),
      
            Spacer(),
      
            !this.canAccess
              ?
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Text(
                    "PRO",
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.white
                    ),
                  ),
                )
              :
                Container(),

            SizedBox(width: 10),

            Image(
              image: AssetImage("resources/images/arrow_right.png"), 
              width: 28, 
              height: 15,
              fit: BoxFit.fitWidth
            )
          ]
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}