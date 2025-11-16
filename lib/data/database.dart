

import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase{
  List toDoList = [];
  final _myBox = Hive.box('mybox');
  void createInitialData(){
    toDoList = [
      ["make a tutorial",false],
      ["wtf",false],
    ];
  }

  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  void updateData(){
    _myBox.put("TODOLIST", toDoList);
  }
}