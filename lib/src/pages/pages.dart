import 'package:flutter/material.dart';

import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../models/route_argument.dart';
import '../pages/favorites.dart';
import '../pages/home.dart';
import '../pages/map.dart';
import '../pages/notifications.dart';
import '../pages/orders.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  int id;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({Key key, this.currentTab, this.id}) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        print("yes");

        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
    print("check id isssssssssssssssssss:");
    print(widget.id);
    print("check id isssssssssssssssssss:");
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    print('old widget is:$oldWidget');
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget(
            parentScaffoldKey: widget.scaffoldKey,
            id: widget.id.toString(),
          );

          break;
        case 1:
          widget.currentPage = MapWidget(
              parentScaffoldKey: widget.scaffoldKey,
              routeArgument: widget.routeArgument);
          break;
        case 2:
          widget.currentPage =
              NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage =
              OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage =
              FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        // case 5:
        //   widget.currentPage = ShoppingCartButtonWidget(
        //     iconColor: Theme.of(context).hintColor,
        //     labelColor: Theme.of(context).accentColor,
        //   );
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        endDrawer: FilterWidget(onFilter: (filter) {
          Navigator.of(context)
              .pushReplacementNamed('/Pages', arguments: widget.currentTab);
        }),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
                title: new Container(height: 5.0),
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 40,
                          offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 13,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.home,
                      color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.local_mall),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              title: new Container(height: 0.0),
            ),
            // BottomNavigationBarItem(
            //   icon: new Icon(Icons.shopping_cart),
            //   title: new Container(height: 0.0),
            // )
          ],
        ),
      ),
    );
  }
}
