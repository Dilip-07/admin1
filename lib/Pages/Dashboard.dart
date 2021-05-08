import 'package:admin1/Bloc/adminbloc.dart';
import 'package:admin1/Config/config.dart';
import 'package:admin1/Pages/admin.dart';
import 'package:admin1/Pages/data_info.dart';
import 'package:admin1/Pages/sign_in.dart';
import 'package:admin1/Pages/upload_tournament.dart';
import 'package:admin1/Utils/next_screen.dart';
import 'package:admin1/Widgets/cover_widget.dart';
import 'package:admin1/pages/Games.dart';
import 'package:admin1/pages/Tournaments.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _pageIndex = 0;

  final List<String> titles = [
    'Data Info',
    'Admin',
    'Tournaments',
    'Add Tournament',
    'Games',
  ];

  final List icons = [
    LineIcons.pie_chart,
    LineIcons.bomb,
    LineIcons.rocket,
    LineIcons.bell,
    LineIcons.users,
  ];

  Future handleLogOut() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp
        .clear()
        .then((value) => nextScreenCloseOthers(context, SignInPage()));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<AdminBloc>().getGames();
    });
  }

  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    return Scaffold(
      appBar: _appBar(ab),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: VerticalTabs(
                  tabBackgroundColor: Colors.white,
                  backgroundColor: Colors.grey[200],
                  tabsElevation: 10,
                  tabsShadowColor: Colors.grey[500],
                  tabsWidth: 200,
                  indicatorColor: KPrimarycolor,
                  selectedTabBackgroundColor:
                      Colors.deepPurpleAccent.withOpacity(0.1),
                  indicatorWidth: 5,
                  disabledChangePageFromContentView: true,
                  initialIndex: _pageIndex,
                  onSelect: (index) {
                    _pageIndex = index;
                  },
                  tabs: <Tab>[
                    tab(titles[0], icons[0]),
                    tab(titles[1], icons[1]),
                    tab(titles[2], icons[2]),
                    tab(titles[3], icons[3]),
                    tab(titles[4], icons[4]),
                  ],
                  contents: <Widget>[
                    DataInfoPage(),
                    CoverWidget(widget: AdminPage()),
                    CoverWidget(widget: Tournamentpage()),
                    CoverWidget(widget: Uploadtournamentpage()),
                    CoverWidget(widget: Games()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tab(title, icon) {
    return Tab(
        child: Container(
      padding: EdgeInsets.only(
        left: 10,
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
            color: Colors.grey[800],
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[900],
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    ));
  }

  Widget _appBar(ab) {
    return PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          height: 60,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300], blurRadius: 10, offset: Offset(0, 5))
          ]),
          child: Row(
            children: <Widget>[
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: KPrimarycolor,
                          fontFamily: 'Muli'),
                      text: Config().appName,
                      children: <TextSpan>[
                    TextSpan(
                        text: ' - Admin Panel',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                            fontFamily: 'Muli'))
                  ])),
              Spacer(),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                    color: KPrimarycolor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ]),
                // ignore: deprecated_member_use
                child: FlatButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  icon: Icon(
                    LineIcons.sign_out,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  onPressed: () => handleLogOut(),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ));
  }
}
