import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product_details';

  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context).settings.arguments as String;
    Product loadedProduct = findById(context, productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        backgroundColor: Colors.white);
  }

  Product findById(BuildContext context, String productId) {
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((element) => element.id == productId);
    return loadedProduct;
  }
}
