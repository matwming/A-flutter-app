import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/Ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final product;
  ProductPage(this.product);
  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Melbourne',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        Text('\$' + price.toString(),
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('asset/food.jpg'),
              ),
              Container(
                child: TitleDefault(product.title),
                padding: EdgeInsets.all(10.0),
              ),
              _buildAddressPriceRow(product.price),
              Container(
                child: Text(product.description,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center),
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.all(5.0),
              ),
            ],
          ))),
      onWillPop: () {
        //we can block the user from going back
        print('back button is pressed!');
        Navigator.pop(context, false);
        return Future.value(
            false); //true means a user can leave the page;this will trigger another pop action
      },
    );
  }
}
