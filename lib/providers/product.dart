import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url =
        'https://shopapp-b2c54-default-rtdb.firebaseio.com/products/$id.json';

    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw HttpException('Could not update product!');
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw HttpException('Something went wrong!');
    }
  }
}
