import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';

class ProductsManage extends StatelessWidget {
  final MainModel model;
  ProductsManage(this.model);
  Widget _buildSideDraw(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        child: Scaffold(
            drawer: _buildSideDraw(context),
            appBar: AppBar(
                title: Text('Products Manage'),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.create), text: 'Create Products'),
                    Tab(icon: Icon(Icons.list), text: 'My products')
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                ProductEditPage(),
                ProductListPage(model),
              ],
            )),
        length: 2); //length means how many tabs we need
  }
}
