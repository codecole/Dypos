import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:ta_andypos/components/TextFields/inputField.dart';

class DetailSupplier extends StatefulWidget {

  _DetailSupplierPage createState() => _DetailSupplierPage();
  final String idICategory;

  final String nama;
  final bool status;

  DetailSupplier({
    Key key, 
    this.nama,this.status,this.idICategory}) : super(key: key);

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

File image;
String filename;
// class _ShowItemPage extends State<ShowItem>{
class _DetailSupplierPage extends State<DetailSupplier>{
  
  String idUser;
  bool updateCheck=false;
  String _category;
  final db = Firestore.instance;
  TextEditingController categoryNameController = new TextEditingController();

_loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
    });
  }
  
  @override
  void initState(){
    super.initState();
    _loadUid();
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Category Sucesfully Updated"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    void dispose() {
      super.dispose();
    }


    void updateData() async{
      // print('update');
      // print(idUser);
      // print(this.widget.idItem);
      _category=categoryNameController.text;
      
        db.collection('owner').document(idUser).collection('category').document(this.widget.idICategory).updateData({
          'value': '$_category',
        });
      
      _showDialog(context);

    }

 Widget uploadArea(){
      // Image image = decodeImage(new Io.File(image).readAsBytesSync());
    return Column(
      children: <Widget>[
        Image.file(image, width:300, height: 100,),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child:
              InkWell(
                child:
                Icon(
                  Icons.update,
                  size:30.0,
                ),
                onTap: (){
                  setState(() {
                    if(updateCheck==false){
                      updateCheck=true;
                    }else{
                      updateCheck=false;
                    }
                  });
                },
              ),
          
          ),
       
        ],
        title: Text("Detail Kategori"),
        
      ),
      body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: 30,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Detail Kategori",
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),

                new SizedBox(
                  height: screenSize.height,
                  child: new Column(
                    children: <Widget>[
                      new Form(
                        //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                              new InputField(
                                controllerFunction: categoryNameController,
                                // initialVal: this.widget.itemName,
                                hintText: "Category Name: ${this.widget.nama}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon:     Icons.category
                                ,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                    
                             
                              SizedBox(height: 10.0,),
                             new RaisedButton(
                                  child:
                                  Text('Update'),
                                  onPressed: () {
                                   
                                    updateData();
                                     dispose();
                                  },
                                ),
                           
                              // Text("Value uid pref is $idUser")
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

}
