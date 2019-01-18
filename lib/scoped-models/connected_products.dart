import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //convert data
import 'dart:async';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
}
mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;
//return a new list
  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'http://elitegen.singtao.ca/wp-content/uploads/elitegen/2015/01/20141228_EN_Nana1.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .post('https://flutter-app-7895a.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
      );
      _products.add(newProduct);
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deletedProductId = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-app-7895a.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'http://elitegen.singtao.ca/wp-content/uploads/elitegen/2015/01/20141228_EN_Nana1.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-app-7895a.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      final int selectedProductIndex = _products.indexWhere((Product product) {
        return product.id == _selProductId;
      });
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-app-7895a.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      print(json.decode(response.body));
      final Map<String, dynamic> productsListData = json.decode(response.body);
      if (productsListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productsListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteState() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteState = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: newFavoriteState,
    );

    _products[selectedProductIndex] = updatedProduct;

    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(id: '110110110', email: email, password: password);
    print('usermodel');
    notifyListeners();
  }

  Future<Map<String, dynamic>> signup(String email, dynamic password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCZ6G6ppv7B-t5e3scNX_rHLWvaytFP0dU',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    print(json.decode(response.body));
    final Map<String, dynamic> responseData = json.decode(response.body);
    return {'success': true, 'message': 'Authentication succeeded'};
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
