library OrangeServer;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';

class TodoServer
{
  DbCollection _TodoCollection;
  static const HOST = "127.0.0.1";
  static const PORT = "8080";
  static const TODOPATH = "/Todos";
  static const TODOADD = "/addTodo";
  static const TODODEL = "/delTodo";
  
  TodoServer()
  {
    print ("okok");
    Db database = new Db("mongodb://$HOST/todo-server");
    database.open().then( (fctRegisterCollection)
      {
      
      _TodoCollection=database.collection("todos");
      });    
  } 



  void start()
  {
    //bind future http server "server" to port & host
  HttpServer.bind("127.0.0.1", 8080).then((HttpServer server)
    { 
    print("ok");
    //once server is binded listen to request
    server.listen( (HttpRequest request)
      //once requests arrive, deal with them
      {
        switch (request.method)
        {
         case "GET":
           handleGET(request);
           break;
         case "POST" :
           handlePOST(request);
           break;
         case "OPTION" :
           handleOPTION(request);
           break;
         default : handleDEFAULT(request);
        }
      },// deal with errors listening
      onError: print("Error"));
    print("Ecoute GET/POST sur http://$HOST:$PORT");
    },//deal with error binding
  onError: print("Error"));
  }

  void handleGET(HttpRequest request) => print ("GET");
  void handlePOST(HttpRequest request)=> print ("POST");
  void handleOPTION(HttpRequest request) => print ("OPT");
  void handleDEFAULT(HttpRequest request) => print ("DEF");




}
