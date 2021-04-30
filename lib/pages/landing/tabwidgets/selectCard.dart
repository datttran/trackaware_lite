import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/pages/landing/tabwidgets/tender_tab_widget.dart';

class SelectCard extends StatelessWidget {
  SelectCard({
    Key key,

    this.height,
    this.width,



    @required this.child,
  })  : super (key: key);

  final Widget child;

  double height;
  double width;





  @override
  Widget build(BuildContext context) {
    double cir = 16;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Stack(
        clipBehavior: Clip.antiAlias,


        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),

              width: width,
              height:height ,
              decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('images/button2.PNG'),
                  fit: BoxFit.cover,
                ),*/
                  gradient: new LinearGradient(
                      colors: [
                        Color(0xff6e1bfa).withOpacity(.5),
                        Color(0xffe01094).withOpacity(.9)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                  borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(cir),
                  bottomLeft: Radius.circular(cir),
                  topLeft: Radius.circular(cir),
                  topRight: Radius.circular(cir),
                ),
                  boxShadow: [/*
                    BoxShadow(
                      color: Color(0xfff32556).withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                    BoxShadow(
                    color: Color(0xffffd58f).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(-1,-1), // changes position of shadow
                  ),*/

                ],

              ),),

          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Opacity(
              opacity: .05,
                child: Container(

                    margin: EdgeInsets.symmetric(horizontal: 20),

                    child: Image.asset('images/noise.jpg', height: height, width: width, fit: BoxFit.cover,))),
          ),

          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.transparent,
              shadowColor: Color(0xffbf8eff),

              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cir)
              ),


              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),

                height: height,

                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Color(0xff9e58ff).withOpacity(0.1),
                        Color(0xcbe5fffd).withOpacity(0)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.circular(cir)
                ),
                child: child,
              ))
        ],
      ),
    );
  }
}


