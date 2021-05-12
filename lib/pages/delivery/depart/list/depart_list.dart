import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trackaware_lite/blocs/list_depart_bloc.dart';
import 'package:trackaware_lite/events/list_depart_event.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/states/list_depart_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

List<Depart> departItems = List<Depart>();
var listDepartBloc;

class DepartPage extends StatefulWidget {
  @override
  _DepartState createState() => new _DepartState();
}

class _DepartState extends State<DepartPage> {
  Widget getDepartList() {
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
                              decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      HexColor(ColorStrings.tenderPartsGradientColorFirst),
                                      HexColor(ColorStrings.tenderPartsGradientColorSecond),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Location", style: const TextStyle(color: const Color(0xff767272), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                          Text(departItems[position].location != null ? departItems[position].location : "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: const Color(0xff202020), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0))
                                        ],
                                      ),
                                      flex: 1),
                                  Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Tracking Number", style: const TextStyle(color: const Color(0xff767272), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                          departItems[position].trackingNo == null
                                              ? Text("")
                                              : Text(departItems[position].trackingNo,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: const Color(0xff202020), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0))
                                        ],
                                      ),
                                      flex: 1),
                                  Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text("Scan Time", style: const TextStyle(color: const Color(0xff767272), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.0)),
                                          departItems[position].scanTime == null
                                              ? Text("")
                                              : Text(departItems[position].scanTime.toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: const Color(0xff202020), fontWeight: FontWeight.w400, fontFamily: "SourceSansPro", fontStyle: FontStyle.normal, fontSize: 13.0))
                                        ],
                                      ),
                                      flex: 1),
                                ],
                              ))),
                    );
                  },
                  itemCount: departItems != null ? departItems.length : 0,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    listDepartBloc = BlocProvider.of<ListDepartBloc>(context);
    listDepartBloc.dispatch(ListDepartItemsEvent());
    Widget getCupertinoScaffold(BuildContext context, ListDepartState state) {
      return Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                var result = await Navigator.of(context).pushNamed('/NewDepartScreen');
                if (result?.toString()?.isNotEmpty == true) {
                  listDepartBloc.dispatch(ListDepartItemsEvent());
                }
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffdac2ff).withOpacity(.4), Color(0xffdac2ff).withOpacity(.6)], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0, 1]),
                      borderRadius: new BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                        child: Icon(AntDesign.plus, color: Color(0xff7e7eff)),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Strings.ADD_NEW,
                            style: TextStyle(color: Color(0xff35357a).withOpacity(.5), fontSize: 16.0),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            departItems.isNotEmpty
                ? getDepartList()
                : Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0.0, 16, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Material(
                                color: Colors.transparent,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/ic_box.svg",
                                    semanticsLabel: "empty icon",
                                    height: 100,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      child: Text(
                                        Strings.NO_DEPART_ITEMS,
                                        style: TextStyle(fontSize: 20.0, color: Color(0xffeaeaff).withOpacity(.6)),
                                      ))
                                ])))))
          ],
        ),
      );
    }

    return BlocListener<ListDepartBloc, ListDepartState>(
        listener: (context, state) {
          if (state is DepartListFetchSuccess) {
            departItems.clear();
            departItems.addAll(state.departList.reversed);
          }
        },
        child: BlocBuilder<ListDepartBloc, ListDepartState>(
            bloc: listDepartBloc,
            builder: (
              BuildContext context,
              ListDepartState state,
            ) {
              return getCupertinoScaffold(context, state);
            }));
  }
}
