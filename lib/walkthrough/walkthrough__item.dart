import 'package:flutter/material.dart';
import 'package:untitled/routes/signup.dart';
import 'package:untitled/routes/welcome_view.dart';
import 'package:untitled/util/colors.dart';


class WalkthroughItem extends StatefulWidget {

  final description;
  final index;
  final totalItem;
  final controller;
  final Map<String, dynamic>? item;

  const WalkthroughItem({Key? key, this.controller, this.description, this.index, this.totalItem, this.item}) : super(key: key);

  @override
  _WalkthroughItemState createState() => _WalkthroughItemState();
}

class _WalkthroughItemState extends State<WalkthroughItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.index == 0 ? [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(widget.item!['image'] ?? '', width: 150,)
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 40),
                  child: widget.item!['description_rich'] ?? Text(""),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: widget.item!['title'] ?? Text(""),
                ),
              ] : [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(widget.item!['image'] ?? '', width: 150,)
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: widget.item!['title'] ?? Text(""),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: widget.item!['description_rich'] ?? Text(""),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onTap: () async {
                if ((widget.index+1) == widget.totalItem) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeView()));
                } else {
                  await widget.controller.animateToPage(widget.index + 1, curve: Curves.easeIn,duration: Duration(milliseconds: 200),);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 52,
                margin: EdgeInsets.only(top: 30, bottom: 60, left: 30, right: 30),
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
                decoration: BoxDecoration(
                  color: AppColors.ButtonColor_Walkthrogh,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.BoxShadow_Walkthrogh,
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Text(
                  widget.item!['button_text'] ?? 'Continue',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteTextColor,
                      fontSize: 16
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}