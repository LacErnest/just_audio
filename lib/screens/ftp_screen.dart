import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:filex/model/record.dart';
import 'package:filex/api/databasehelper.dart';
import 'package:filex/screens/main_screen.dart';

import 'styles.dart';

class FTPScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FTPScreenState();
  }
}

class _FTPScreenState extends State<FTPScreen> {
  final List<Record> records = [];
  List<Record> allRecords = [];
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    getRecords();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Latest Records", style: Styles.navBarTitle,)),
      body: ListView.builder(
        itemCount: this.records.length,
        itemBuilder: _listViewItemBuilder
        )
    );
  }
  
  Widget _listViewItemBuilder(BuildContext context, int index){
    var record = this.records[index];
    return ListTile(
      //contentPadding: EdgeInsets.all(10.0),
      leading: FlutterLogo(size: 72.0),
      title: _itemTitle(record),
      subtitle: _itemSubTitle(record),
      trailing: Icon(Icons.more_vert),
      isThreeLine: true,
      );
  }

  

  //void _navigationToNewsDetail(BuildContext context, NewsDetail newsDetail){
  // Navigator.push(
  //    context, 
  //    MaterialPageRoute(
  //      builder: (context){return NewsInfo(newsDetail);}
  //  ));
  //}

  Widget _itemThumbnail(Record record){
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: FlutterLogo(size: 72.0),
    );
  }

  Widget _itemTitle(Record record){
    return Text(record.name, style: Styles.textDefault);
  }

  Widget _itemSubTitle(Record record){
    final formatDate = DateFormat('yyyy-dd-MM HH:mm:ss');
    return Text(formatDate.format(record.created_at));
  }

  void getRecords() async{
    final records = await databaseHelper.getRecords() as List;
    for (Record record in records) {
      allRecords.add(record);
    }
    allRecords.forEach((r){
      setState(() {
        records.add(r);
      });
    });
  }

}