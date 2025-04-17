import 'package:flutter/material.dart';

void main() => runApp(ShoppingApp());

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shop',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ShopScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Item {
  final String name;
  final double price;
  Item(this.name, this.price);
}

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Item> items = [
    Item('T-Shirt', 499.0),
    Item('Jeans', 999.0),
    Item('Sneakers', 1999.0),
    Item('Watch', 1499.0),
    Item('Sunglasses', 799.0),
  ];

  final List<Item> cart = [];

  void addToCart(Item item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to cart')),
    );
  }

  void viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartScreen(cart: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: viewCart,
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(item.name, style: TextStyle(fontSize: 18)),
              subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () => addToCart(item),
                child: Text('Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Item> cart;

  CartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? Center(child: Text('Your cart is empty!'))
                  : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: Text('₹${item.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.payment),
                label: Text('Checkout'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Checkout feature coming soon!')),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
