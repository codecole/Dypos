// import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:ta_andypos/theme/style.dart';
import '../home.dart';
// import 'updateSupplier.dart' as updatePage;
import 'list.dart' as addPage;
import 'show.dart' as showPage;
// import '../home.dart';
// import 'modelSupplier.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../drawerBar.dart';
void main() => runApp(MasterReturPembelianPage());

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final supplierKey = const Key('supplierKey');
}

class MasterReturPembelianPage extends StatefulWidget {
  final String email,passwordValue;

  MasterReturPembelianPage({Key key, this.email, this.passwordValue}) : super(key: key);

  @override
  _MasterReturPembelianPageState createState() => _MasterReturPembelianPageState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/img/login_logo.png'),
  fit: BoxFit.cover,
);

TextStyle headingStyle = new TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

class _MasterReturPembelianPageState extends State<MasterReturPembelianPage> with SingleTickerProviderStateMixin
{
  String dropdownValue;
  final db = Firestore.instance;
  String idUser;
  String id;
  String _email;
  String role;
  var userNameController;
  var error;
  final GlobalKey<FormState> _formKeySupplier = new GlobalKey<FormState>();
  TabController controller;
  
 _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
      _email = (prefs.getString ('email')??'');
      role = (prefs.getString ('role')??'');
      if(idUser==null){
       CircularProgressIndicator();
      }
      print("Load IdUSer");
      print(idUser);
      print(_email);
    });
  }

  @override
  void initState(){
      controller = new TabController(vsync: this, length: 2);
    _loadUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
          ],
        backgroundColor: Theme.Colors.loginGradientStart,
        title:     
          InkWell(
            child:  new Text('Master Retur Pembelian'),
            onTap:(){
                Navigator.push(
                    context,
                  MaterialPageRoute(builder: (context) => Home(user: _email)) ,
                );
                dispose();
            }
          ),
        bottom: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home), text: "List Item",),
            // new Tab(icon: new Icon(Icons.update),text: "Update",),  
            new Tab(icon: new Icon(Icons.settings_backup_restore), text: "History Retur",),  
          ]
        ),
      ),
      drawer:buildDrawer(context,idUser,_email,role),
        key: _formKeySupplier,
        body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new showPage.ShowPage(controller: controller,),
          // new updatePage.UpdatePage(controller: controller,),
          new addPage.ListReturPage(controller:controller),
        ]
      ),
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () => controller.animateTo((controller.index + 1)%2 ), // Switch tabs
      //   child: new Icon(Icons.swap_horiz),
      // ),
      );
  }

}

