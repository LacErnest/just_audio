import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:dio/dio.dart';
import 'package:filex/model/record.dart';

class DatabaseHelper{

  String serverUrl = "http://cobrain.pythonanywhere.com";//"https://recorder-call.herokuapp.com";//https://7262d598983f.ngrok.io";
  var status ;
  var token ;
  //typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
  //typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

  loginData(String username , String password) async{
    print("login In...");
    String myUrl = "$serverUrl/rest-auth/login/";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "username": "$username",
          "password" : "$password"
        } ) ;
    print(response.body);
    status = response.body.contains('error');
    print(status);
    var data = json.decode(response.body);

    if(status){
      print('data : ${data["error"]}');
    }else{
      print('data : ${data["key"]}');
      _save(data["key"]);
    }
  }

  registerData(String name ,String email , String password) async{
    print("Processing...");
    String myUrl = "$serverUrl/rest-auth/registration/";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "username": "$name",
          "email": "$email",
          "password1" : "$password",
          "password2" : "$password"
        } ) ;
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if(status){
      print('data : ${data["error"]}');
    }else{
      print('data : ${data["key"]}');
      _save(data["key"]);
    }
  }


  Future<List<Record>> getRecords() async{
    print("Fetching...");
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrl/records/";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Token $value'
    });
    print(response.body);
    var audios = json.decode(response.body);
    var data = audios["results"] as List;
    print(data);
    data.map((e)=>print('item: $e'));
    var records = data.map((e) => Record.fromJson(e)).toList();
    print('total $records');
    //return 
    return records;
  }

  uploadFile(file) async{
      print("Uploading...");
     //create multipart request for POST or PATCH method
     String myUrl = "$serverUrl/records/";
     final prefs = await SharedPreferences.getInstance();
     final key = 'token';
     final value = prefs.get(key ) ?? 0;

     var request = http.MultipartRequest("POST", Uri.parse(myUrl));
     
     //create multipart using filepath, string or bytes
     request.headers["Authorization"] = "Token $value";
     var rec = await http.MultipartFile.fromPath("audio", file.path);

     //add multipart to request
     request.files.add(rec);
     var response = await request.send();

     //Get the response from the server
     var responseData = await response.stream.toBytes();
     var responseString = String.fromCharCodes(responseData);
     print(responseString);
  }

  Future<String> fileDownload(String id, String fileName) async {
    assert(fileName != null);
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    final url = Uri.encodeFull('$serverUrl/download/$id');

    final HttpClient httpClient = HttpClient();

    final request = await httpClient.getUrl(Uri.parse(url));

    request.headers.add(HttpHeaders.contentTypeHeader, "application/octet-stream");
    request.headers.add(HttpHeaders.authorizationHeader, "Token $value");

    var httpResponse = await request.close();

    int byteCount = 0;
    int totalBytes = httpResponse.contentLength;

    //Directory appDocDir = await getApplicationDocumentsDirectory();
    

    //appDocPath = "/storage/emulated/0/Download";
    //var myDir = new Directory('/storage/emulated/0/Biv_Records');
    //String appDocPath = myDir.path;
    File file;
    final path = '/storage/emulated/0/Download';
    final checkPathExistence = await Directory(path).exists();
    if(checkPathExistence){
      file = new File(path + "/" + fileName);
    }else{
      var myDir = new Directory('/storage/emulated/0/Download');
      file = new File(path + "/" + fileName);
    }


    var raf = file.openSync(mode: FileMode.write);

    Completer completer = new Completer<String>();

    httpResponse.listen(
      (data) {
        byteCount += data.length;

        raf.writeFromSync(data);

        //if (onDownloadProgress != null) {
        //  onDownloadProgress(byteCount, totalBytes);
        //}
      },
      onDone: () {
        raf.closeSync();

        completer.complete(file.path);
      },
      onError: (e) {
        raf.closeSync();
        file.deleteSync();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

 read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('read : $value');
  }
}


