import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/generated/l10n.dart';
import 'package:markets/src/controllers/product_controller.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:markets/src/models/product.dart';
import 'package:markets/src/models/route_argument.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class FeaturedItemWidget extends StatefulWidget {
  final List<Product> featuredProducts;
  FeaturedItemWidget({this.featuredProducts});
  @override
  _FeaturedItemWidgetState createState() => _FeaturedItemWidgetState();
}

class _FeaturedItemWidgetState extends StateMVC<FeaturedItemWidget> {
  ProductController con;

  _FeaturedItemWidgetState() : super(ProductController()) {
    con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.featuredProducts.length,
          itemBuilder: (_, index) {
            return InkWell(
              splashColor: Theme.of(context).accentColor,
              focusColor: Theme.of(context).accentColor,
              highlightColor: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.of(context).pushNamed('/Product',
                    arguments: RouteArgument(
                        id: widget.featuredProducts[index].id,
                        heroTag: S.of(context).featured_products));
              },
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 100,
                        width: 80,
                        child: CachedNetworkImage(
                            imageUrl:
                                widget.featuredProducts[index].image.url)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.featuredProducts[index].name}",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.purple,
                          child: Helper.getPrice(
                            widget.featuredProducts[index].price,
                            context,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              con.incrementQuantity();
                              // con.addToCart(widget.product);
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                if (con.isSameMarkets(con.product)) {
                                  con.addToCart(con.product);
                                }
                              }
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
