import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loader = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Random random = Random();

  inputDialouge() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Title",
                        label: Text('Title'),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                  child: TextField(
                    controller: descripController,
                    decoration: InputDecoration(
                        hintText: "Description",
                        label: Text('Description'),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      elevation: 20,
                    ),
                    onPressed: () async {
                      setState(() {
                        loader = true;
                      });

                      var toDoModel = ToModel(
                          id: random.nextInt(100),
                          title: titleController.text,
                          description: descripController.text,
                          dateTime:
                              DateFormat().add_jm().format(DateTime.now()));
                      await _databaseHelper.addToDoMethod(toDoModel);
                      Navigator.pop(context);
                      setState(() {
                        loader = false;
                      });
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          inputDialouge();
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('ToDo'),
        elevation: 5,
        centerTitle: true,
      ),
      body: Container(
        child: loader
            ? Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : FutureBuilder(
                future: _databaseHelper.getToDoModel(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ToModel>?> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                title: Text("${snapshot.data![index].title}"),
                                subtitle: Text(
                                    "${snapshot.data![index].description}"),
                                trailing:
                                    Text("${snapshot.data![index].dateTime}"),
                              );
                            }),
                          ),
                        ),
                      );
                    }
                  }
                  return Container();
                }),
      ),
    );
  }
}
