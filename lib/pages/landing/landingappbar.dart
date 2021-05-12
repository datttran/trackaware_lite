import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trackaware_lite/constants.dart';
import 'package:trackaware_lite/globals.dart' as globals;
import 'package:trackaware_lite/utils/bubble_tab_indicator.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/utils/utils.dart';

class LandingAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget _userProfileImage;
  final Widget _settingsImage;
  final TabController _tabController;

  LandingAppBar(this._userProfileImage, this._settingsImage, this._tabController);
  @override
  State<StatefulWidget> createState() => new LandingAppBarState(_userProfileImage, _settingsImage, _tabController);

  @override
  Size get preferredSize => new Size.fromHeight(160.0);
}

GlobalKey<LandingAppBarState> landingAppBarKey = GlobalKey<LandingAppBarState>();

class LandingAppBarState extends State<LandingAppBar> {
  Widget _userProfileImage;
  Widget _settingsImage;
  TabController _tabController;

  final List<Tab> driverTabs = <Tab>[
    new Tab(text: Strings.pickUpTitle),
    new Tab(text: Strings.deliveryTitle),
  ];

  final List<Tab> tenderTabs = <Tab>[
    new Tab(text: Strings.pickUpTitle),
    new Tab(text: Strings.deliveryTitle),
  ];

  LandingAppBarState(this._userProfileImage, this._settingsImage, this._tabController);

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: landingAppBarKey,
      decoration: new BoxDecoration(
        color: Colors.transparent,
      ),
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20.3, 0, 0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: _userProfileImage,
                onTap: () {
                  Navigator.of(context).pushNamed('/Profile');
                },
              ),
              Text(Strings.trackaware_title,
                  style: TextStyle(
                    color: Color(0xff665a5a),
                    fontSize: 15,
                    fontFamily: 'SourceSansPro-Bold',
                  )),
              GestureDetector(
                child: _settingsImage,
                onTap: () {
                  Navigator.of(context).pushNamed('/Settings');
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          ),
          new TabBar(
            isScrollable: true,
            unselectedLabelColor: HexColor(ColorStrings.unselectedLabelColor),
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 46.0,
              indicatorColor: HexColor(ColorStrings.unselectedLabelColor),
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: globals.isDriverMode ? driverTabs : tenderTabs,
            controller: _tabController,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LandingAppBarImage extends StatefulWidget implements PreferredSizeWidget {
  final Widget _userProfileImage;
  final Widget _settingsImage;
  final TabController _tabController;

  LandingAppBarImage(this._userProfileImage, this._settingsImage, this._tabController);
  @override
  State<StatefulWidget> createState() => new LandingAppBarImageState(_userProfileImage, _settingsImage, _tabController);

  @override
  Size get preferredSize => new Size.fromHeight(verticalPixel * 13);
}

class LandingAppBarImageState extends State<LandingAppBarImage> {
  Widget _userProfileImage;
  Widget _settingsImage;
  TabController _tabController;

  final List<Tab> driverTabs = <Tab>[
    new Tab(
      text: Strings.pickUpTitle,
    ),
    new Tab(text: Strings.deliveryTitle),
  ];

  final List<Tab> tenderTabs = <Tab>[
    new Tab(text: Strings.pickUpTitle),
    new Tab(text: Strings.deliveryTitle),
  ];

  LandingAppBarImageState(this._userProfileImage, this._settingsImage, this._tabController);

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return new Container(
      height: verticalPixel * 40,
      key: landingAppBarKey,
      decoration: new BoxDecoration(
        color: Colors.red.withOpacity(0),
      ),
      child: new Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                height: verticalPixel * 12,
                width: horizontalPixel * 97,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: horizontalPixel * 3.5),
                decoration: BoxDecoration(
                  color: Color(0xff2C2C34),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0), bottom: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*GestureDetector(
                      child: _userProfileImage,
                      onTap: () {
                        Navigator.of(context).pushNamed('/Profile');
                      },
                    ),*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          width: horizontalPixel * 80,
                        ),
                        Container(
                          width: horizontalPixel * 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('T R A C K A W A R E', style: TextStyle(color: Color(0xff689ffd), fontSize: verticalPixel * 3.4)),
                              GestureDetector(
                                child: Column(
                                  children: [
                                    _settingsImage,
                                  ],
                                ),
                                onTap: () async {
                                  var result = await Navigator.of(context).pushNamed('/Settings');

                                  if (result?.toString()?.isNotEmpty == true) {}
                                },
                              ),
                            ],
                          ),
                        ),
                        Text(' DELIVERY EXPERIENCE PLATFORM', style: TextStyle(color: Color(0xff93b1ee), fontSize: verticalPixel * 1.3)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, verticalPixel * 1),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
