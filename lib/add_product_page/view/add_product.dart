import 'package:ecommerce/add_product_page/repo/add_product_repo.dart';
import 'package:ecommerce/custom_widgets/page_title.dart';
import 'package:ecommerce/custom_widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _productSerialController =
      TextEditingController();

  final TextEditingController _productPriceController = TextEditingController();

  List<XFile>? productImages;
  //Picking Image From Device Storage
  Future<dynamic> pickImage() async {
    final imagePicker = ImagePicker();
    productImages = await imagePicker.pickMultiImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              mainHeading('Add A Product'),
              heightSpacer(20),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  hintText: 'Product Name',
                ),
              ),
              TextFormField(
                controller: _productSerialController,
                decoration: InputDecoration(
                  hintText: 'Serial Number',
                ),
              ),
              TextFormField(
                controller: _productPriceController,
                decoration: InputDecoration(
                  hintText: 'Price',
                ),
              ),
              heightSpacer(10),
              TextButton(
                  onPressed: pickImage,
                  child: Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.orange),
                  )),
              // heightSpacer(10),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await AddProductRepo().createImageTask(
                        _productNameController.text,
                        _productSerialController.text,
                        _productPriceController.text,
                        productImages!,
                      );
                      // clearing fields on submit
                      _productNameController.clear();
                      _productSerialController.clear();
                      _productPriceController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Product Added!')));
                    }
                  },
                  child: Text('Add Product'))
            ],
          ),
        ),
      ),
    );
  }
}
