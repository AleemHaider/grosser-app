import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/controllers/market_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

// ignore: must_be_immutable
class CardWidget extends StatefulWidget {
  Market market;
  String heroTag;
  final RouteArgument routeArgument;

  CardWidget({Key key, this.market, this.heroTag, @required this.routeArgument})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends StateMVC<CardWidget> {
  MarketController _con;

  _CardWidgetState() : super(MarketController()) {
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _con.listenForFeaturedProducts(widget.routeArgument.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Hero(
                tag: this.widget.heroTag + widget.market.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color:
                            widget.market.closed ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.circular(24)),
                    child: widget.market.closed
                        ? Text(
                            S.of(context).closed,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            S.of(context).open,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: Helper.canDelivery(widget.market)
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(24)),
                    child: Helper.canDelivery(widget.market)
                        ? Text(
                            S.of(context).delivery,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            S.of(context).pickup,
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            widget.market.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: Helper.getStarsList(
                                double.parse(widget.market.rate)),
                          ),
                          Row(
                            children: [
                              _con.featuredProducts.length > 0
                                  ? Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                        _con.featuredProducts[0].name
                                            .toString(),
                                      ))),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                      // Text(
                      //   Helper.skipHtml(market.description),
                      //   overflow: TextOverflow.fade,
                      //   softWrap: false,
                      //   style: Theme.of(context).textTheme.caption,
                      // ),
                      // SizedBox(height: 5),
                      // Row(
                      //   children:
                      //       Helper.getStarsList(double.parse(market.rate)),
                      // ),
                    ],
                  ),
                ),
                // SizedBox(width: 15),
                // Expanded(
                //   child: Column(
                //     children: <Widget>[
                //       FlatButton(
                //         padding: EdgeInsets.all(0),
                //         onPressed: () {
                //           Navigator.of(context).pushNamed('/Pages',
                //               arguments:
                //                   new RouteArgument(id: '1', param: market));
                //         },
                //         child: Icon(Icons.directions,
                //             color: Theme.of(context).primaryColor),
                //         color: Theme.of(context).accentColor,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(5)),
                //       ),
                //       market.distance > 0
                //           ? Text(
                //               Helper.getDistance(
                //                   market.distance,
                //                   Helper.of(context)
                //                       .trans(setting.value.distanceUnit)),
                //               overflow: TextOverflow.fade,
                //               maxLines: 1,
                //               softWrap: false,
                //             )
                //           : SizedBox(height: 0)
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
