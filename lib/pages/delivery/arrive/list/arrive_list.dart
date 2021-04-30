import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackaware_lite/blocs/list_arrive_bloc.dart';
import 'package:trackaware_lite/events/list_arrive.event.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/states/list_arrive_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:flutter_icons/flutter_icons.dart';
List<Arrive> arriveItems = List<Arrive>();
var listArriveBloc;

class ArrivePage extends StatefulWidget {
  @override
  _ArriveState createState() => new _ArriveState();
}

class _ArriveState extends State<ArrivePage> {
  Widget getArriveList() {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
            child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  shrinkWrap: false,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushReplacementNamed('/TenderPartsScreen');
                      },
                      child: Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                              height: 60,
                              decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      HexColor(ColorStrings
                                          .tenderPartsGradientColorFirst),
                                      HexColor(ColorStrings
                                          .tenderPartsGradientColorSecond),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      18.0, 8.0, 18.0, 14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Location",
                                            style: TextStyle(
                                                color: HexColor(
                                                    ColorStrings.tenderHeading),
                                                fontSize: 13.0,
                                                fontFamily: 'SourceSansPro',
                                                fontStyle: FontStyle.normal),
                                          ),
                                          Text(
                                            arriveItems[position].location,
                                            style: TextStyle(
                                                color: HexColor(
                                                    ColorStrings.tenderValues),
                                                fontSize: 13.0,
                                                fontFamily: 'SourceSansPro',
                                                fontStyle: FontStyle.normal),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text("Scan Time",
                                              style: TextStyle(
                                                  color: HexColor(ColorStrings
                                                      .tenderHeading),
                                                  fontSize: 13.0,
                                                  fontFamily: 'SourceSansPro',
                                                  fontStyle: FontStyle.normal)),
                                          Text(
                                              arriveItems[position].scanTime ==
                                                      null
                                                  ? " - "
                                                  : arriveItems[position]
                                                      .scanTime
                                                      .toString(),
                                              style: TextStyle(
                                                  color: HexColor(ColorStrings
                                                      .tenderValues),
                                                  fontSize: 13.0,
                                                  fontFamily: 'SourceSansPro',
                                                  fontStyle: FontStyle.normal))
                                        ],
                                      ),
                                    ],
                                  )))),
                    );
                  },
                  itemCount: arriveItems.isNotEmpty ? arriveItems.length : 0,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    listArriveBloc = BlocProvider.of<ListArriveBloc>(context);
    listArriveBloc.dispatch(ListArriveItemsEvent());
    Widget getCupertinoScaffold(BuildContext context, ListArriveState state) {
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () async {
                var result =
                    await Navigator.of(context).pushNamed('/NewArriveScreen');
                if (result?.toString()?.isNotEmpty == true) {
                  listArriveBloc.dispatch(ListArriveItemsEvent());
                }
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xffdac2ff).withOpacity(.4),
                            Color(0xffdac2ff).withOpacity(.6)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1]
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(16))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                        child: Icon(AntDesign.plus , color: Color(0xff7e7eff),),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 4,),
                          Text(
                            Strings.ADD_NEW,
                            style:
                                TextStyle(color: Color(0xff35357a).withOpacity(.5), fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            arriveItems.isNotEmpty
                ? getArriveList()
                : Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Material(
                                color: Colors.transparent,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        "assets/ic_box.svg",
                                        semanticsLabel: "empty icon",
                                        height: 100,


                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          child: Text(
                                            Strings.NO_ARRIVE_ITEMS,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color:
                                                Color(0xffeaeaff).withOpacity(.6)),
                                          ))
                                    ])))))
          ],
        ),
      );
    }

    return BlocListener<ListArriveBloc, ListArriveState>(
        listener: (context, state) {
          if (state is ArriveListFetchSuccess) {
            arriveItems.clear();
            arriveItems.addAll(state.arriveList.reversed);
          }
        },
        child: BlocBuilder<ListArriveBloc, ListArriveState>(
            bloc: listArriveBloc,
            builder: (
              BuildContext context,
              ListArriveState state,
            ) {
              return getCupertinoScaffold(context, state);
            }));
  }
}
