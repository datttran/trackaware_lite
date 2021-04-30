import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackaware_lite/blocs/tender_tab_bloc.dart';
import 'package:trackaware_lite/events/tender_tab_event.dart';
import 'package:trackaware_lite/states/tender_tab_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'selectCard.dart';

class TenderTabWidget extends StatefulWidget {
  @override
  TenderTab createState() => TenderTab();
}

TenderTabBloc _tenderTabBloc;
int tenderPartCount = -1;
int tenderExternalCount = -1;

class TenderTab extends State<TenderTabWidget> {
  @override
  void dispose() {
    _tenderTabBloc = null;
    tenderPartCount = -1;
    tenderExternalCount = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _tenderList = [
      globals.tenderProductionPartsDispName,
      globals.tenderExternalPackagesDispName
    ];
    return BlocProvider(
        builder: (context) {
          return TenderTabBloc();
        },
        child: BlocListener<TenderTabBloc, TenderTabState>(
            listener: (context, state) async {
              if (state is FetchExternalTenderSuccess) {
                tenderExternalCount = state.count;
                _tenderTabBloc.dispatch(ResetEvent());
              }

              if (state is FetchTenderPartSuccess) {
                tenderPartCount = state.count;
                _tenderTabBloc.dispatch(ResetEvent());
              }
            },
            child: BlocBuilder<TenderTabBloc, TenderTabState>(
                bloc: _tenderTabBloc,
                builder: (
                  BuildContext context,
                  TenderTabState state,
                ) {
                  if (_tenderTabBloc == null)
                    _tenderTabBloc = BlocProvider.of<TenderTabBloc>(context);

                  if (tenderPartCount == -1)
                    _tenderTabBloc.dispatch(FetchTenderPartsCount());

                  if (tenderExternalCount == -1)
                    _tenderTabBloc.dispatch(FetchTenderExternalCount());

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5 ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [

                                  Color(0xffd6bdff).withOpacity(.8),
                                  Colors.deepPurpleAccent.withOpacity(0),

                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,

                              ),
                              borderRadius: BorderRadius.circular(20),

                            ),
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0 ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: ListView.builder(
                              itemBuilder: (context, position) {
                                return GestureDetector(
                                    onTap: () async {
                                      if (position == 1) {
                                        final result = await Navigator.of(context)
                                            .pushNamed('/TenderExternalScreen').then((value){
                                              setState(() {

                                              });
                                        });

                                        if (result?.toString()?.isNotEmpty == true) {
                                          _tenderTabBloc
                                              ?.dispatch(FetchTenderExternalCount());
                                        }
                                      } else {
                                        final result = await Navigator.of(context)
                                            .pushNamed('/TenderPartsScreen').then((value){
                                              setState(() {

                                              });
                                        });
                                        if (result?.toString()?.isNotEmpty == true) {
                                          _tenderTabBloc
                                              ?.dispatch(FetchTenderPartsCount());
                                        }
                                      }
                                    },
                                    child: SelectCard(
                                      key: UniqueKey(),



                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          //Image.asset('images/ic_truck.png'),
                                          Text(_tenderList[position],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,

                                          ),


                                          ),
                                          _tenderList[position] ==
                                                  Strings.TENDER_PRODUCTION_PARTS
                                              ? getDisplayCountWidget(
                                                  tenderPartCount == -1
                                                      ? 0.toString()
                                                      : tenderPartCount
                                                          .toString())
                                              : getDisplayCountWidget(
                                                  tenderExternalCount == -1
                                                      ? 0.toString()
                                                      : tenderExternalCount
                                                          .toString()),

                                        ],
                                      ),
                                    ));
                              },
                              itemCount: _tenderList.length,
                            )),
                      ),
                    ),
                  );
                })));
  }
}

Widget getDisplayCountWidget(String count) {
  return count == 0.toString()
      ? ClipOval(
      child: Container(
        alignment: Alignment.center,
        height: 20,
        width: 20,
        color: Color(0xfff0ccff),
        //padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: null,
      ))
      : ClipOval(
          child: Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
          color: Color(0xffff5e8f),
          //padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: Text(
            count,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));
}
