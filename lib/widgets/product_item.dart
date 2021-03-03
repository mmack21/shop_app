import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                try {
                  await product.toggleFavoriteStatus();
                } catch (error) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop();
                        });
                        return AlertDialog(
                          title: product.isFavourite
                              ? Text('Disliking this item failed!')
                              : Text('Making this item favorite failed!'),
                          content: Center(
                            child: Text(
                              error.toString(),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.price,
                  product.title,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(
                      label: 'Undo adding to cart',
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
