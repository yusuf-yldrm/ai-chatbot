import 'package:flutter/material.dart';

class PurchaseButton extends StatefulWidget {
  
  final String title;
  final String description;
  final ValueNotifier<bool> isSelected;
  final VoidCallback? onPressed;

  const PurchaseButton({
    Key? key, 
    required this.title, 
    required this.description,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PurchaseButtonState();
}

class PurchaseButtonState extends State<PurchaseButton> {

  get borderRadius => BorderRadius.circular(8);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        child: Row(children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),

            Spacer(),

            Text(
              widget.description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey
              ),
            ),
          ]
        )
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        side: BorderSide(width: 1, color: widget.isSelected.value ? Colors.white : Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}