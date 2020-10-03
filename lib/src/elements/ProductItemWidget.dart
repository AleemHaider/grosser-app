import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/elements/AddToCartAlertDialog.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/product_controller.dart';

import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductItemWidget extends StatefulWidget {
  final String heroTag;
  final Product product;
  final RouteArgument routeArgument;
  final String id;

  const ProductItemWidget(
      {Key key, this.product, this.heroTag, this.routeArgument, this.id})
      : super(key: key);

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends StateMVC<ProductItemWidget> {
  ProductController con;

  _ProductItemWidgetState() : super(ProductController()) {
    con = controller;
  }
  @override
  void initState() {
    con.listenForProduct(productId: widget.routeArgument.id);
    con.listenForCart();
    con.listenForFavorite(productId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: RouteArgument(
                id: widget.product.id, heroTag: this.widget.heroTag));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.heroTag + widget.product.id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: widget.product.image.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Row(
                          children:
                              Helper.getStarsList(widget.product.getRate()),
                        ),
                        Text(
                          widget.product.options
                              .map((e) => e.name)
                              .toList()
                              .join(', '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(
                        widget.product.price,
                        context,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      widget.product.discountPrice > 0
                          ? Helper.getPrice(
                              widget.product.discountPrice, context,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      decoration: TextDecoration.lineThrough)))
                          : SizedBox(height: 0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              con.decrementQuantity();
                            },
                            iconSize: 30,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            icon: Icon(Icons.remove_circle_outline),
                            color: Theme.of(context).hintColor,
                          ),
                          Text(con.quantity.toString(),
                              style: Theme.of(context).textTheme.subtitle1),
                          IconButton(
                            onPressed: () {
                              con.incrementQuantity();
                              // con.addToCart(widget.product);
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                if (con.isSameMarkets(con.product)) {
                                  con.addToCart(con.product);
                                } else {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     // return object of type Dialog
                                  //     return AddToCartAlertDialogWidget(
                                  //         oldProduct:
                                  //             con.carts.elementAt(0)?.product,
                                  //         newProduct: con.product,
                                  //         onPressed: (product, {reset: true}) {
                                  //           return con.addToCart(con.product,
                                  //               reset: true);
                                  //         });
                                  //   },
                                  // );
                                }
                              }
                            },
                            iconSize: 30,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            icon: Icon(Icons.add_circle_outline),
                            color: Theme.of(context).hintColor,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
