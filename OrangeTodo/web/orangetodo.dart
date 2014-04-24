import 'dart:html';
//import '../../OrangeTodoServer/Lib/TodoServer.dart';
import 'dart:async';
import 'dart:convert';


// elements linked to HTML form
UListElement todoList; // List containing todos
ParagraphElement statusText; // status text paragraph.

// main routine
void main() {
  // create dart object from html elements using id identificator
  todoList = querySelector('#todoList');
  statusText = querySelector('#statusText');
  
  statusText.text = "Loading contents ...";
  // get list pf todos from the server
  getTodosFromServer("http://127.0.0.1:6060/")
  .then((todos){displayTodosInHTMLList(todos,todoList);})
  .then((_){statusText.text = "Done";});
}


/**
 * This function returns a Future<List<Map>> provided by the server
 * It sends a GET request to specified URI.
 */
Future<List<Map>> getTodosFromServer(String iServerURL) {
  Completer returnCompleter = new Completer();
  
  //var path = "ToDoListServerDB.db.json";
  HttpRequest.getString(iServerURL)
   .then((stringFromServer){returnCompleter.complete(getTodoListFromString(stringFromServer));});
  return returnCompleter.future;
}


/**
 * This function returns a Future list of todo maps from a JSON string.
 */
Future<List<Map>> getTodoListFromString (String iJSONTodoList) {
  Completer returnCompleter = new Completer();
  // try to automatically decode input string... and put it in a list of maps
  returnCompleter.complete(JSON.decode(iJSONTodoList));
  return returnCompleter.future;
}


/**
 * This function instert todo "value" from a todo list in LIElement in a UListElemnt
 * provided in the input.
 */
displayTodosInHTMLList(List<Map> todoList,UListElement displayHTMLList){
  
  for (Map itTodo in todoList) {
    //create a list element from the input
    LIElement newListElement = new LIElement();
    newListElement.text = itTodo["value"];
    //add this new list element to the list container
    displayHTMLList.append(newListElement);
  }
 
  
  
}
