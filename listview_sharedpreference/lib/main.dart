import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart';

void main() {
  runApp(const MaterialApp(home: ItemListPage()));
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<ItemModel> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<ItemModel> _foundItems = [];

  final List<ItemModel> _dummyItems = [
    ItemModel(id: 1, name: 'Laptop', description: 'Laptop gaming'),
    ItemModel(id: 2, name: 'Mouse', description: 'Mouse wireless'),
    ItemModel(id: 3, name: 'Keyboard', description: 'Keyboard mechanical'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      setState(() {
        _foundItems = _items;
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ItemModel> results = [];

    if(enteredKeyword.isEmpty) {
      results = _items;
    } else {
      results = _items.where((item) => item.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundItems = results;
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('items_list');
    if (itemsString != null) {
      List<dynamic> itemsMap = json.decode(itemsString);
      setState(() {
        _items = itemsMap.map((item) => ItemModel.fromMap(item)).toList();
      });
    } else {
      setState(() {
        _items = List.from(_dummyItems);
      });
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsMap = _items.map((item) => item.toMap()).toList();
    String itemsString = json.encode(itemsMap);
    await prefs.setString('items_list', itemsString);
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan deskripsi tidak boleh kosong')),
      );
      return;
    }
    int newId = _items.isNotEmpty ? _items.last.id + 1 : 1;
    ItemModel newItem = ItemModel(
      id: newId,
      name: _nameController.text,
      description: _descController.text,
    );
    setState(() {
      _items.add(newItem);
    });
    await _saveData();
    _nameController.clear();
    _descController.clear();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item berhasil ditambahkan')),
    );
  }

  void _showEditDialog(ItemModel item) {
    _nameController.text = item.name;
    _descController.text = item.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Item')),
              TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Deskripsi')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final index = _items.indexWhere((i) => i.id == item.id);
                  _items[index] = ItemModel(
                    id: item.id,
                    name: _nameController.text,
                    description: _descController.text,
                  );
                });
                _saveData();
                _nameController.clear();
                _descController.clear();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(int id) async {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
    await _saveData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item berhasil dihapus')),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Item Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Item')),
              TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Deskripsi')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(onPressed: _addItem, child: const Text('Simpan')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Item')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Cari Item',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _foundItems.isEmpty
                ? const Center(child: Text('Data tidak ditemukan'))
                : ListView.builder(
                    itemCount: _foundItems.length, // Gunakan _foundItems
                    itemBuilder: (context, index) {
                      final item = _foundItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${item.id}')),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item.description),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditDialog(item);
                              } else if (value == 'delete') {
                                _deleteItem(item.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                              const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

