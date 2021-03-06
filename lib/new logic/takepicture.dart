import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_part_db.dart';

List<PickUpPart> devList = [];
List _items = [];

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    getDeliveryList();
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();

    _items.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff171721),

      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(child: Text('Proof of Delivery (POD)', style: TextStyle(color: Color(0xff6ecaff)))),
                ),
                CameraPreview(_controller),
                SizedBox(height: verticalPixel * 2),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.
                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;

                          // Attempt to take a picture and get the file `image`
                          // where it was saved.
                          final image = await _controller.takePicture();

                          // If the picture was taken, display it on a new screen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                // Pass the automatically generated path to
                                // the DisplayPictureScreen widget.
                                imagePath: image?.path,
                              ),
                            ),
                          );
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print(e);
                        }
                      },
                      child: Container(
                          height: verticalPixel * 9,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff4b92fc), Color(0xff4353de)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(00.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white70,
                                ),
                                Text(
                                  '      Capture',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          //height: verticalPixel * 5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffec686c), Color(0xffff2f47)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(00.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.clear,
                                  color: Colors.white70,
                                ),
                                Text(
                                  '       Cancel ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void getDeliveryList() {
  globals.deliveryList.forEach((element) {
    if (element.isSelected == true) {
      devList.add(element);
      _items.add(element);
    }
  });
}

void confirmDelivery(devList) {}

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
_getAllItem() {
  List<Item> lst = _tagStateKey.currentState?.getAllItem;
  if (lst != null) lst.where((a) => a.active == true).forEach((a) => print(a.title));
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Widget getTags() {
    return Tags(
      key: _tagStateKey,

      itemCount: _items.length, // required
      itemBuilder: (int index) {
        final item = _items[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item.orderNumber,
          active: item.isSelected,
          pressEnabled: false,

          activeColor: Color(0xff6889ec),

          textStyle: TextStyle(
            fontSize: 14,
          ),
          combine: ItemTagsCombine.withTextBefore,

          removeButton: ItemTagsRemoveButton(
            onRemoved: () {
              print(_items.length);
              setState(() {
                _items[index].isSelected = false;
                _items.removeAt(index);

                globals.deliveryList[index].isSelected = false;
                globals.selectedCard = globals.selectedCard - 1;
              });
              // Remove the item from the data source.

              //required
              return true;
            },
          ), // OR null,
          onPressed: (item) => print(item),
          onLongPressed: (item) => print(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('en', 'US'),
      //You have to set this parameters to your locale
      textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
      backgroundColor: Color(0x99000000),
      borderRadius: BorderRadius.circular(5.0),
      textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      toastAnimation: StyledToastAnimation.size,
      reverseAnimation: StyledToastAnimation.size,
      startOffset: Offset(0.0, -1.0),
      reverseEndOffset: Offset(0.0, -1.0),
      duration: Duration(seconds: 4),
      animDuration: Duration(seconds: 1),
      alignment: Alignment.center,
      toastPositions: StyledToastPosition.center,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
      dismissOtherOnShow: true,
      fullWidth: false,
      isHideKeyboard: false,
      isIgnoring: true,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff171721),

        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: verticalPixel * 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(height: verticalPixel * 50, child: Image.file(File(widget.imagePath))),
                  ),
                  Column(
                    children: [
                      Text('Order selected:', style: TextStyle(color: Colors.white70)),
                      SizedBox(
                        height: verticalPixel * 2,
                      ),
                      getTags(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPixel * 4, vertical: verticalPixel * 3),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          minLines: 7,
                          maxLines: 10,
                          style: TextStyle(color: Color(0xffc5c5cb)),
                          onChanged: (value) {
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                            hintText: 'Note',
                            hintStyle: TextStyle(color: Colors.white70.withOpacity(.2)),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff8091ff), width: .5),
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff4d5cde), width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: verticalPixel * 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_items.isNotEmpty) {
                        setState(() {
                          _items.forEach((element) {
                            globals.deliveryList.remove(element);
                            globals.delivered = globals.delivered + 1;
                            globals.selectedCard = globals.selectedCard - 1;
                          });

                          showToast('Success!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);

                          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                        });
                      } else {
                        showToast('No item was selected.', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                      }
                    },
                    child: Container(
                        width: horizontalPixel * 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff68b3ec), Color(0xff434bde)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
