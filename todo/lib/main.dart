import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TODO LIST'),
    );
  }
}

class Item {
  String name;
  String Price;
  bool isCompleted;

  Item({required this.name, required this.Price, this.isCompleted = false});
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  // TaskScreen({required this.item});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  void addChanges() {
    final String name = _nameController.text;
    final String Price = _priceController.text;
    // widget.item.isCompleted = widget.item.isCompleted;
    if (name.isNotEmpty && Price.isNotEmpty) {
      final newItem = Item(name: name, Price: Price);
      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 72, 61, 61),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'ADD TASK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/todo-image2.png'),
                    fit: BoxFit.cover)),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text("Add Task",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    TextField(
                      controller: _nameController,
                    ),
                    SizedBox(height: 30),
                    Text("Add Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    TextField(
                      controller: _priceController,
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black)),
                            onPressed: addChanges,
                            child: Text("Add Task")))
                  ],
                ))));
  }
}

class EditScreen extends StatefulWidget {
  // const EditScreen({super.key});
  final Item item;
  final Function(Item) onSave;
  EditScreen({required this.item, required this.onSave});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _priceController = TextEditingController(text: widget.item.Price);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
  }

  void saveChanges() {
    final newName = _nameController.text;
    final newPrice = _priceController.text;
    widget.item.name = newName;
    widget.item.Price = newPrice;
    widget.item.isCompleted = widget.item.isCompleted;
    widget.onSave(widget.item);
    // setState(() {
    //   widget.item.name = newName;
    //   widget.item.Price = newPrice;
    // });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 72, 61, 61),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'EDIT TASK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 10.0,
              image: AssetImage('assets/todo-image2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Change your Task',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextField(
                    controller: _nameController,
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Change your Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextField(
                    controller: _priceController,
                    maxLines: 5,
                  ),
                  SizedBox(height: 30),
                  Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: saveChanges,
                        child: Text("Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      )),
                ],
              )),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dat = "";
  DateTime initialDate = DateTime.now();
  // DateFormat _dateFormat = DateFormat('MMMM dd, yyyy hh:mm a');
  // DateTime? _selectedDate;
  // TextEditingController _textEditingController = TextEditingController();
  // TextEditingController _textEditingController2 = TextEditingController();
  List<Item> _itemList = [];
  int count = 0;
  void editValue(Item item) async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          item: item,
          onSave: (updatedItem) {
            setState(() {
              // Update the item in the list
              final index = _itemList.indexOf(item);
              if (index != -1) {
                _itemList[index] = updatedItem;
              }
            });
          },
        ),
      ),
    );
  }

  void addValue() async {
    final newItem = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskScreen(),
        ));
    if (newItem != null) {
      setState(() {
        _itemList.add(newItem);
        count = _itemList.length;
      });
    }
  }

  bool _textfield = false;
  void _toggleTextField() {
    setState(() {
      _textfield = !_textfield;
    });
  }

  void deleteRow(String itemName) {
    setState(() {
      _itemList.removeWhere((item) => item.name == itemName);
      count = _itemList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 72, 61, 61),
          elevation: 1000,
          title: Row(children: [
            SizedBox(width: 100),
            Icon(
              Icons.today_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text("TOODLEDO",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/todo-image2.png'),
                    fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  //width: 20,
                  height: 70,
                ),
                Row(children: [
                  SizedBox(
                    width: 40,
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: _itemList.length,
                        itemBuilder: ((context, index) {
                          final item = _itemList[index];
                          return Card(
                              child: ListTile(
                                  leading: const Icon(Icons.task),
                                  title: Text(
                                    '${item.name}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      decoration: item.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${item.Price}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Container(
                                      width: 150,
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () {
                                                deleteRow(item.name);
                                              },
                                              icon: Icon(Icons.delete,
                                                  color: const Color.fromARGB(
                                                      255, 72, 61, 61))),
                                          IconButton(
                                              onPressed: () {
                                                editValue(item);
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: const Color.fromARGB(
                                                    255, 72, 61, 61),
                                              )),
                                          Checkbox(
                                              checkColor: Colors.white,
                                              focusColor: Colors.black,
                                              activeColor: const Color.fromARGB(
                                                  255, 72, 61, 61),
                                              value: item.isCompleted,
                                              onChanged: (value) {
                                                setState(() {
                                                  item.isCompleted =
                                                      value ?? false;
                                                });
                                              })
                                        ],
                                      ))));
                        }))),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: ElevatedButton(
                          onPressed: addValue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 72, 61, 61),
                            shape: CircleBorder(),
                            minimumSize: Size(60, 60),
                          ),
                          child: Icon(Icons.add)),
                    ))
              ],
            )));
  }
}
