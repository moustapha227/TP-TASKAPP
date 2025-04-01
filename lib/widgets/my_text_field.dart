import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyTextField({
    super.key,
    required this.hint,
    required this.title,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        Container(
          height: 60,
          width: 375,
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.only(left: 14),
          decoration: BoxDecoration(
            //color: Colors.grey,
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(fontSize: 20),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                    ),
                  ),
                ),
              ),
              widget == null ? Container() : Container(child: widget),
            ],
          ),
        ),
      ],
    );
  }
}
