import 'package:flutter/material.dart';
import 'dart:async';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  ProductPage(this.title, this.imageUrl);
  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Image.asset(imageUrl),
              Container(
                child: Text(title),
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                  child: RaisedButton(
                      child: Text('Delete'),
                      color: Theme.of(context).accentColor,
                      onPressed: () => _showWarningDialog(context)),
                  padding: EdgeInsets.all(10.0)),
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
