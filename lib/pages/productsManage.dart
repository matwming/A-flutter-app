import 'package:flutter/material.dart';
import './product_create.dart';
import './product_list.dart';

class ProductsManage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;
  ProductsManage(this.addProduct, this.deleteProduct);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        child: Scaffold(
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  AppBar(
                    automaticallyImplyLeading: false,
                    title: Text('Choose'),
                  ),
                  ListTile(
                    title: Text('All Products'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/products');
                    },
                  )
                ],
              ),
            ),
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
                ProductCreatePage(addProduct),
                ProductListPage(),
              ],
            )),
        length: 2); //length means how many tabs we need
  }
}
