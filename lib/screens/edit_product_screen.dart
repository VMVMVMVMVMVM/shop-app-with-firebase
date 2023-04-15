import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';


class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    quantity: 0,
    isFavourite: false,
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        FirebaseDatabase.instance
            .ref()
            .child("Products")
            .child(productId)
            .get()
            .then((value) {
          _editedProduct =
              Product.fromJson(jsonDecode(jsonEncode(value.value)));
          _titleController.text = _editedProduct.title;
          _descriptionController.text = _editedProduct.description;
          _priceController.text = _editedProduct.price.toString();
          _imageUrlController.text = _editedProduct.imageUrl;
        });
        /*_editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);*/

      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https') ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('something went wrong'),
            actions: [
              ElevatedButton(
                child: Text('okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
      //finally {
      //setState(() {
      //_isLoading = false;
      //});
      //Navigator.of(context).pop();
      //}
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print("Save Icon Pressed");
              String productId = "";
              if (_editedProduct.id.isEmpty) {
                productId = DateTime.now().millisecondsSinceEpoch.toString();
              } else {
                productId = _editedProduct.id;
              }

              Product newProduct = Product(
                  id: productId,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  price: double.parse(_priceController.text),
                  imageUrl: _imageUrlController.text,
                  quantity: 1,
                  isFavourite: false);

              FirebaseDatabase.instance
                  .ref()
                  .child("Products")
                  .child(newProduct.id)
                  .set(newProduct.toJson())
                  .then((value) {
                Navigator.of(context).pop();
              });

              //_saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value!,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      quantity: _editedProduct.quantity,
                      isFavourite: _editedProduct.isFavourite);
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a price';
                  }
                  if (double.parse(value) == null) {
                    return 'please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'please enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value == null ? "0" : value),
                      imageUrl: _editedProduct.imageUrl,
                      quantity: _editedProduct.quantity,
                      isFavourite: _editedProduct.isFavourite);
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a description';
                  }
                  if (value.length < 10) {
                    return 'should be at least 10 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      quantity: _editedProduct.quantity,
                      isFavourite: _editedProduct.isFavourite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      /*onFieldSubmitted: (_) {
                              _saveForm();
                            },*/
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter an image url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'please enter a valid URL';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'please enter a valid image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _imageUrlController.text,
                            quantity: _editedProduct.quantity,
                            isFavourite: _editedProduct.isFavourite);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
