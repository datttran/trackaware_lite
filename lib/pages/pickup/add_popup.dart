import 'dart:ui';
import 'package:trackaware_lite/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackaware_lite/globals.dart' as globals;
class Pop extends StatefulWidget {
  final int showID;
  static String id = 'pop_up';

  Pop(this.showID);
  @override
  _PopState createState() => _PopState();
}

class _PopState extends State<Pop> {
  var left = Colors.black;
  var right =  Colors.white;

  int shareValue;
  colorCheck(){
    if(shareValue == 0){
      userPages = setColor(Colors.black,Colors.white);
    }
    else{
      userPages = setColor(Colors.white,Colors.black,);
    }

    return userPages;
  }
  Map userPages;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    shareValue = widget.showID;
    userPages = colorCheck();


    _pageController = PageController(initialPage: shareValue);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  void _onButtonPress(val) {
    _pageController.animateToPage(val,
        duration: Duration(milliseconds: 550), curve: Curves.decelerate);
    setState(() {

      if(val == 0){

        userPages = setColor(Colors.black, Colors.white);


      }
      else{

        userPages = setColor(Colors.white, Colors.black);


      }


    });
  }


  void onPageChange(val){

  }



  PageController _pageController;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        SizedBox(
          height: verticalPixel*12.3,
        ),
        Container(
          height: verticalPixel*75,
          width: horizontalPixel*90,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: horizontalPixel*70,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: <Widget>[
                          CupertinoSlidingSegmentedControl(
                            padding: EdgeInsets.symmetric(horizontal: verticalPixel),
                            onValueChanged: (int val){
                              shareValue = val;
                              _onButtonPress(val);






                            },
                            children: userPages,
                            groupValue: shareValue ,
                          ),
                          buildPageView(),

                          //loginBoxes[shareValue],
                        ],
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );



  }

buildPageView() {
    return Container(
      height: verticalPixel*65,

      child: PageView(
        onPageChanged: (int val){
          shareValue = val;
          _onButtonPress(val);

        },

        controller: _pageController,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[

                  SizedBox(
                    height: horizontalPixel*23,

                  ),

                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    style: TextStyle(
                      color: Color(0xffc5c5cb)
                    ),
                    keyboardType: TextInputType.number,

                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    decoration: InputDecoration(

                      hintText: 'Enter the barcode',
                      hintStyle: TextStyle(
                        color: Colors.white70.withOpacity(.2)
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xff3f3272), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xff3e27a4), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: verticalPixel*6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: MaterialButton(
                        elevation: 0,
                        //color: Color(0xff7663E9),
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        onPressed: () {

                        },

                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff68b3ec),
                                Color(0xff8543de) ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,

                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: verticalPixel*.7, horizontal: verticalPixel*3.4),
                            child: FittedBox(
                              child: Text('Add',
                                style: TextStyle(color: Colors.white, fontSize: verticalPixel*1.5  ,fontStyle: FontStyle.normal),),
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
              child: null)
        ],
      ),
    );
  } // return PageView
}


setColor(left  , right){
  return  {
    0: Text('Auto', style: TextStyle(color: left),),
    1: Text('Manual', style: TextStyle(color: right), )
  };
}

var left = Colors.black;
var right =  Colors.white;

