import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  final _sampleCrud = Hive.box('sample_CRUD');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _sampleCrud.keys.map((key) {
      final item = _sampleCrud.get(key);
      return {
        "key": key,
        "name": item["name"],
        "quantity": item["quantity"],
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
      print(_items.length);
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _sampleCrud.add(newItem);
    _refreshItems();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _sampleCrud.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey) async {
    await _sampleCrud.delete(
      itemKey,
    );
    _refreshItems();
  }

  void showForm({required BuildContext context, int? itemKey}) async {
    if (itemKey != null) {
      final existingItem = _items.firstWhere((e) => e['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(hintText: 'quantity'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (itemKey == null) {
                          _createItem({
                            "name": _nameController.text,
                            "quantity": _quantityController.text
                          });
                        }
                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "name": _nameController.text,
                            "quantity": _quantityController.text
                          });
                        }
                        _quantityController.text = '';
                        _nameController.text = '';
                        Navigator.of(context).pop();
                      },
                      child: Text(itemKey == null ? 'Create a new' : 'update')),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('sample CRUD with hive'),
        ),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Card(
              color: Colors.orange.shade100,
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: ListTile(
                title: Text(currentItem['name']),
                subtitle: Text(currentItem['quantity'].toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => showForm(
                        context: context,
                        itemKey: currentItem['key'],
                      ),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _deleteItem(currentItem['key']),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showForm(
            context: context,
            itemKey: null,
          ),
          child: const Icon(Icons.add),
        ),
      );
}
