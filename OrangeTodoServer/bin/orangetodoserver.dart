import 'dart:io';
import 'dart:async';
import '../Lib/TodoServer.dart';




void main() {
  print("Server starting");
  
  var ServerForTodo = new TodoServer();
  ServerForTodo.start();
}


