import 'package:flutter/material.dart';
import './pages/auth.dart';
import './pages/product.dart';
import './pages/productsHome.dart';
import './pages/productsManage.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './models/product.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}
// returns nothing

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepPurple,
            //fontFamily: 'Oswald'
          ),
          //home: AuthPage(),
          routes: {
            '/': (BuildContext context) => AuthPage(),
            '/products': (BuildContext context) => ProductsHomePage(model),
            '/admin': (BuildContext context) => ProductsManage(model),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final String productId = (pathElements[2]);
              final Product product =
                  model.allProducts.firstWhere((Product product) {
                return product.id == productId;
              });
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product),
              );
            }
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => ProductsHomePage(model));
          },
        ));
  }
}
