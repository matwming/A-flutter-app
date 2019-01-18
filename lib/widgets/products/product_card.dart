import 'package:flutter/material.dart';
import 'price_tag.dart';
import '../Ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product products;
  final int productIndex;
  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(products.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(products.price.toString())
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed<bool>(
                  context, '/product/' + model.allProducts[productIndex].id)),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoriteState();
            },
            color: Colors.red,
          )
        ],
      );
    });
  }

  ProductCard(this.products, this.productIndex);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(products.image),
            placeholder: AssetImage('assets/background.jpg'),
            height: 300.0,
            fit: BoxFit.cover,
          ),
          _buildTitlePriceRow(),
          AddressTag('Melbourne'),
          Text(products.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
