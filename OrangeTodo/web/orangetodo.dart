import 'dart:html';
//import '../../OrangeTodoServer/Lib/TodoServer.dart';

import 'dart:convert';


UListElement todoList;
ParagraphElement para;
void main() {
  todoList = querySelector('#todoList');
  para = querySelector('#towrite');
  new Element.tag('p');
  getDataFromServer();
}



void getDataFromServer() {
  var path = "ToDoListServerDB.db.json";
  HttpRequest.getString("http://127.0.0.1:6060/")
   .then(processString);
  // .catchError(handleGetError);
}

void processString (String iString) {
  para.text = iString;
  // try to automatically decode input string... and put it in a list of maps
  List<Map> listOfTodosMap = JSON.decode(iString);
  for (Map itTodo in listOfTodosMap) {
  //create a list element from the input
  LIElement newListElement = new LIElement();
  newListElement.text = itTodo["value"];
  //add this new list element to the list container
  todoList.append(newListElement);
  para.text = "fuckin' A ! that's like a diode lighting up !";
  }
  
}