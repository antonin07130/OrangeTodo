import 'dart:io';
import 'dart:async';
import '../Lib/TodoServer.dart';

void main() {
  print("FYI");
  var ServerForTodo = new TodoServer();
  ServerForTodo.start();
}


