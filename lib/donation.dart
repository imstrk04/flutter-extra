import 'package:flutter/material.dart';

void main() {
  runApp(DonationApp());
}

class DonationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DonationHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DonationItem {
  final String imageUrl;
  final String description;
  String status;

  DonationItem({required this.imageUrl, required this.description, this.status = 'In Progress'});
}

class DonationHomePage extends StatefulWidget {
  @override
  _DonationHomePageState createState() => _DonationHomePageState();
}

class _DonationHomePageState extends State<DonationHomePage> {
  List<DonationItem> donations = [];

  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _addDonation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Donation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  donations.add(
                    DonationItem(
                      imageUrl: imageUrlController.text,
                      description: descriptionController.text,
                    ),
                  );
                });
                imageUrlController.clear();
                descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateStatus(DonationItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('In Progress'),
              onTap: () {
                setState(() {
                  item.status = 'In Progress';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Collected'),
              onTap: () {
                setState(() {
                  item.status = 'Collected';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Delivered'),
              onTap: () {
                setState(() {
                  item.status = 'Delivered';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation List'),
      ),
      body: donations.isEmpty
          ? Center(child: Text('No donations yet. Add some!'))
          : ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final item = donations[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
              ),
              title: Text(item.description),
              subtitle: Text('Status: ${item.status}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _updateStatus(item),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDonation,
        child: Icon(Icons.add),
      ),
    );
  }
}
