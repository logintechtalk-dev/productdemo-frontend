import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  List<Product> products = [];
  Product? editingProduct;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await ProductApi.getAllProducts();
    setState(() {});
  }

  void resetForm() {
    _nameController.clear();
    _priceController.clear();
    _qtyController.clear();
    editingProduct = null;
  }

  Future<void> saveOrUpdateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    Product product = Product(
      id: editingProduct?.id,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      quantity: int.parse(_qtyController.text),
    );

    bool success;
    if (editingProduct == null) {
      success = await ProductApi.saveProduct(product);
    } else {
       success = await ProductApi.updateProduct(product.id!, product);
    }

    if (success) {
      resetForm();
      loadProducts();
    }
  }

  void editProduct(Product p) {
    setState(() {
      editingProduct = p;
      _nameController.text = p.name;
      _priceController.text = p.price.toString();
      _qtyController.text = p.quantity.toString();
    });
  }

  Future<void> deleteProduct(int id) async {
    await ProductApi.deleteProduct(id);
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Management")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORM
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (v) =>
                          v!.isEmpty ? "Enter product name" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Enter price" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: const InputDecoration(labelText: "Quantity"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Enter quantity" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: saveOrUpdateProduct,
                    child: Text(editingProduct == null ? "Save" : "Update"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final p = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text("₹${p.price} | Qty: ${p.quantity}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editProduct(p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteProduct(p.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
