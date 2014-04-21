library OrangeServer;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';


/// TodoServer should answer to specific Get and Post request.
/// receive POST to add/remove a todo, answer with status (success or failure)
/// receive GET and answer with todo list
class TodoServer
{
  DbCollection _TodoCollection;
  HttpServer _ServerHttp;
  static const HOST = "127.0.0.1";
  static const PORT = 6060;
  static const TODOPATH = "/Todos";
  static const TODOADD = "/addTodo";
  static const TODODEL = "/delTodo";
  
  TodoServer()
  {
    //initialize database object
    Db database = new Db("mongodb://$HOST/todo-server");
    // open mongodb connection and todos database
    database.open().then((_){
      _TodoCollection=database.collection("todos");
      }).then((_){
        print ("Database :" + database.databaseName + "\nCollection :" + _TodoCollection.collectionName );
        });
    // TODO:ERROR HANDELING
  } 
  
  
  /*
   * 
   * TODO :  
  SendActiveTodoList
  
  SendAllTodoList
  
  SearchTodoList
  
  SendTodo
  
  GetNewTodo
  
  */
  
  /// Returns a list of maps, each map beeing a todo.
  /// Returned maps are identified by _id value which is their id in the database
  /// (in order to provide a REST API, objects must be identified to be modified or destroyed).
  Future<List<Map>> GetAllTodos()
  {
    return _TodoCollection.find(where.fields(["_id","done","value"])).toList();
  }
  
  /// input todoMongo map must have following format :
  ///  todoMap={
  ///    "done" : "$Boolean",
  ///    "value" : "NameOfTodo"
  ///    };
  Future<int> AddTodo(Map todoMongo)
  {
    /*
    // store input in a map
    var todoMongo = new Map();
    todoMongo={
    "done" : "$iDone",
    "value" : iValue
    };
    */
    return     _TodoCollection.insert(todoMongo,writeConcern: WriteConcern.ACKNOWLEDGED).catchError((e){print("duplicatedindex");});
  }

  
  void start()
  {
    
   // Deprecated _ServerHttp = new HttpServer();
    
    //server.addRequestHandler(bool matcher(HttpRequest request), void handler(HttpRequest request, HttpResponse response))
  //bind future http server "server" to port & host
  HttpServer.bind(HOST, PORT).then((HttpServer server)
    { 
    _ServerHttp = server;
    print("OrangeServer binded to $HOST:$PORT");
    //once server is binded listen to request
    server.listen( (HttpRequest request)
      //once requests arrive, deal with them
      {
      //throw new StateError('door locked');
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
      }//,// deal with errors listening
      //onError: print("Error")
      );
    print("OrangeServer listening on http://$HOST:$PORT");
    })
    .catchError((e) // not working yet
      {
      print ("got error server listening error :${e.error}");
      });
    }

  void handleGET(HttpRequest request){
    //DEBUG
    print("requestGet");
    print("${request.headers}");
    //DEBUG
    
    GetAllTodos().then((List<Map> todoList){
      HttpResponse response = request.response;
      response.headers.contentType = new ContentType("text", "plain", charset: "utf-8");
      addCorsHeaders(response);
      
      response.write(JSON.encode(todoList));
      response.close();
    } );
    
    //return _completerHttpResponse.future;
  }
  
  

  
  void handlePOST(HttpRequest request)=> print (request.headers);
  void handleOPTION(HttpRequest request) => print ("OPT");
  void handleDEFAULT(HttpRequest request) => print ("DEF");

  /**
   * Add Cross-site headers to enable accessing this server from pages
   * not served by this server
   * 
   * See: http://www.html5rocks.com/en/tutorials/cors/ 
   * and http://enable-cors.org/server.html
   */
  void addCorsHeaders(HttpResponse res) {
    res.headers.add("Access-Control-Allow-Origin", "*, ");
    res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
    res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  }


}
