import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:signature/signature.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/models/pickup_part_db.dart';

List<PickUpPart> devList = [];
List _items = [];

/// example widget showing how to use signature widget
class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(0xff539eff),
    exportBackgroundColor: Color(0xff171721),
  );

  @override
  void initState() {
    getDeliveryList();
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    super.dispose();

    _items.clear();
    print('selected card num is' + globals.selectedCard.toString());
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null) lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }

  void getDeliveryList() {
    globals.deliveryList.forEach((element) {
      if (element.isSelected == true) {
        devList.add(element);
        _items.add(element);
      }
    });
  }

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

          activeColor: Color(0xff446af3),

          textStyle: TextStyle(
            fontSize: 14,
          ),
          combine: ItemTagsCombine.withTextBefore,

          removeButton: ItemTagsRemoveButton(
            onRemoved: () {
              setState(() {
                _items.removeAt(index);
                _items[index].isSelected = false;
                globals.deliveryList[index].isSelected = false;
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
        backgroundColor: Color(0xff171721),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            getTags(),

            //SIGNATURE CANVAS
            Signature(
              controller: _controller,
              height: MediaQuery.of(context).size.height - 170,
              backgroundColor: Color(0xff171721),
            ),
            TextField(
              onChanged: (value) {
                globals.receiver = value;
              },
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                  hintText: "Receiver name",
                  filled: true,
                  fillColor: Color(0xff2C2C34),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide.none,
                  )),
            ),
            //OK AND CLEAR BUTTONS
            Container(
              height: 70,
              decoration: const BoxDecoration(color: Color(0xff171721)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE

                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.redAccent,
                    onPressed: () {
                      setState(() => _controller.clear());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.greenAccent,
                    onPressed: () async {
                      if (_controller.isNotEmpty) {
                        final Uint8List data = await _controller.toPngBytes();
                        if (data != null && globals.receiver != null) {
                          try {
                            setState(() {
                              _items.forEach((element) {
                                globals.deliveryList.remove(element);
                                globals.delivered = globals.delivered + 1;
                                globals.selectedCard = globals.selectedCard - 1;
                              });
                              showToast('Success!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);

                              Navigator.pop(context);
                            });
                          } catch (e) {
                            showToast('Please sign first!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                          }

                          // Action here

                        } else if (data != null && globals.receiver == null) {
                          showToast('Please type in receiver name', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                        }
                      } else {
                        showToast('Please sign first!', context: context, axis: Axis.horizontal, alignment: Alignment.center, position: StyledToastPosition.center);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
