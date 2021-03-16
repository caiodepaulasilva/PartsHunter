//Flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


import 'package:partshunter/models/todo.dart';

//Application
import 'dart:convert';

import 'package:partshunter/stores/parts_database.dart';

//Screens

//Stores

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  PartsDatabaseStore store = PartsDatabaseStore();

  final firebase = FirebaseDatabase.instance.reference();




  @override
  void initState() {
    store.Get_Firebase_and_Convert_to_JSON();
    
     //store.Snapshot_to_JSON(snapshot: snapshot);
  }
  

  int scaffoldBottomIndex = 1;

  void scaffoldBottomOnTap(int index) {
    setState(() {
      scaffoldBottomIndex = index;
    });
  }

  

  createData(String category, String description, String drawer) async {
    Todo todo = new Todo(description, drawer);

    await firebase.reference().child(category).push().set(todo.toJson());
  }

  readData() async {
    await firebase.once().then((DataSnapshot _snapshot) {
      print('Data : ${_snapshot.value}');
    });
  }




  getCategory(String category) async {

    await firebase.child(category).once().then((DataSnapshot _snapshot) {
      store.Snapshot_to_JSON(snap: _snapshot);
    });

    
  }

  void deleteData(String drawer) {
    firebase.child('flutterDevsTeam1').remove();
  }

  void updateData(String drawer, String description) {
    firebase.child('flutterDevsTeam1').update({'description': 'TESTE'});
  }

  String Current_Selected_DropDown_Value;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: scaffoldBottomIndex,
        onTap: scaffoldBottomOnTap,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color.fromRGBO(65, 91, 165, 1.0),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.library_add), label: "New"),
          BottomNavigationBarItem(icon: Icon(Icons.keyboard_hide_outlined), label: "Keypad"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, left: 0, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.grey[600], style: BorderStyle.solid, width: 0.80)),
                    child: Observer(builder: (_) {
                      return DropdownButton<String>(
                        underline: SizedBox(),
                        hint: Text("Category"),
                        isExpanded: true,
                        value: Current_Selected_DropDown_Value,
                        onChanged: (String newValue) {                          
                          setState(() {
                            Current_Selected_DropDown_Value = newValue;                            
                          });

                          store.Fill_DataTrable_from_Selected_Category(Current_Selected_DropDown_Value);                          
                        },
                        items: store.dropDownMenuItems,
                      );
                    }),
                  ),
                ),
                Container(
                  child: TextButton(
                      onPressed: () {
                        getCategory(Current_Selected_DropDown_Value);
                        print(Current_Selected_DropDown_Value);
                      },
                      child: Text(
                        'List All',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(41, 55, 109, 1.0)),
                          side: MaterialStateProperty.all(BorderSide(width: 2, color: Color.fromRGBO(41, 55, 109, 1.0))),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)))),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10, left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 40,
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                        ),
                      )),
                ),
                Container(
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(41, 55, 109, 1.0)),
                          side: MaterialStateProperty.all(BorderSide(width: 2, color: Color.fromRGBO(41, 55, 109, 1.0))),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)))),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                createData("RESISTOR", "100R", "99");
              },
              child: Text("CREATE")),
          TextButton(onPressed: readData, child: Text("READ")),
          //TextButton(onPressed: updateData, child: Text("UPDATE")),
          //TextButton(onPressed: deleteData, child: Text("DELETTE")),
  
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]),
              ),
              child: Observer(builder: (_) {
                    return DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'CATEGORY',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'DESCRIPTION',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'DRAWER',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(store.DataTable_Length, (index) { 
                        return DataRow(
                                  cells: [
                                    DataCell(Text(store.JSON_Obj[index]["Category"])),
                                    DataCell(Text(store.JSON_Obj[index]["Description"])),
                                    DataCell(Text(store.JSON_Obj[index]["Drawer"])),
                                  ]);
                            }
                        ),
                    );
              })),        
        ],
      ),
    );
  }


}
