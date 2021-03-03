import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void _plusItem() {
    setState(() {
      widget.quantity = widget.quantity + 1;
    });
  }

  void _minusItem() {
    setState(() {
      widget.quantity = widget.quantity - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget amountField = Transform.scale(
      scale: 0.5,
      child: (Center(
        heightFactor: 0.6,
        widthFactor: 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'btn1',
              onPressed: _minusItem,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            Text(
              '${widget.quantity}',
              style: new TextStyle(fontSize: 60.0),
            ),
            FloatingActionButton(
              heroTag: 'btn2',
              onPressed: _plusItem,
              child: new Icon(
                  const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                  color: Colors.black),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      )),
    );

    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure>'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).deleteItem(widget.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${widget.price}'),
                ),
              ),
            ),
            title: Text(widget.title),
            subtitle: Text(
              'Total: \$${(widget.price * widget.quantity)}',
            ),
            trailing: Container(
              child: amountField,
              width: 40,
            ),
          ),
        ),
      ),
    );
  }
}
