import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  final _controller = TextEditingController();

  //task list
  List toDoList = [
      ["make a tutorial",false],
      ["wtf",false],
    ];
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      db.loadData();
    }
    super.initState();
  }
  // checkbox
  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1] = ! db.toDoList[index][1];
    });
    db.updateData();
}
  // save new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }
  // create new tasks
  void createNewTask(){
    showDialog(
      context: context,
      builder: (context){
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: ()=> Navigator.of(context).pop(),
        );
      },);
  }  
  // delete task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        title: Text("Todo Lists Pages",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        
        onPressed: createNewTask,
        child: Icon(Icons.add),),
      body: ListView.builder(
        itemCount:db.toDoList.length,
        itemBuilder: (context, index) {
         return TodoList(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value)=> checkBoxChanged(value, index), 
            deleteFunction: (context)=> deleteTask(index),
            );
        },),
    );
  }
}