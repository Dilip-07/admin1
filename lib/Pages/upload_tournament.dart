import 'package:admin1/Bloc/adminbloc.dart';
import 'package:admin1/Config/config.dart';
import 'package:admin1/Utils/dialog.dart';

import 'package:admin1/Utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Uploadtournamentpage extends StatefulWidget {
  Uploadtournamentpage({Key key}) : super(key: key);

  @override
  _UploadtournamentpageState createState() => _UploadtournamentpageState();
}

class _UploadtournamentpageState extends State<Uploadtournamentpage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'Tournaments';
  List paths = [];
  final int _commentsCount = 0;
  String _date;
  String _timestamp;
  bool uploadStarted = false;

  var gameSelection;

  TextEditingController organizationnameController = TextEditingController();
  TextEditingController organizationinfoController = TextEditingController();
  TextEditingController tournamentnameController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController image1Controller = TextEditingController();
  TextEditingController image2Controller = TextEditingController();
  TextEditingController image3Controller = TextEditingController();
  TextEditingController tournamentsdetailsController = TextEditingController();
  TextEditingController rulesController = TextEditingController();
  TextEditingController prizepoolController = TextEditingController();
  TextEditingController contactvenueController = TextEditingController();

  clearFields() {
    organizationnameController.clear();
    organizationinfoController.clear();
    tournamentnameController.clear();
    startdateController.clear();
    enddateController.clear();
    image1Controller.clear();
    image2Controller.clear();
    image3Controller.clear();
    tournamentsdetailsController.clear();
    rulesController.clear();
    prizepoolController.clear();
    contactvenueController.clear();
    FocusScope.of(context).unfocus();
  }

  void handleSubmit() async {
    if (gameSelection == null) {
      openDialog(context, 'Select Games First', '');
    } else {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();

        setState(() => uploadStarted = true);
        await getDate().then((_) async {
          await saveToDatabase().then((value) =>
              context.read<AdminBloc>().increaseCount('tournaments_count'));
          setState(() => uploadStarted = false);
          openDialog(context, 'Uploaded Successfully', '');
          clearFields();
        });
      }
    }
  }

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _timestamp = _t;
      _date = _d;
    });
  }

  Future saveToDatabase() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(_timestamp);

    var _tournamentsData = {
      'game': gameSelection,
      'organization-name': organizationnameController.text,
      'organization-info': organizationinfoController.text,
      'tournament-name': tournamentnameController.text,
      'start-date': startdateController.text,
      'end-date': enddateController.text,
      'image1': image1Controller.text,
      'image2': image2Controller.text,
      'image3': image3Controller.text,
      'tournament-details': tournamentsdetailsController.text,
      'rules': rulesController.text,
      'prize-pool': prizepoolController.text,
      'contact-venue': contactvenueController.text,
      'comments-count': _commentsCount,
      'date': _date,
      'timestamp': _timestamp
    };
    await ref.set(_tournamentsData);
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: h * 0.10,
              ),
              Text(
                'Add Tournaments',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                width: 1000,
                decoration: BoxDecoration(
                    color: KPrimarycolor,
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(
                height: 70,
              ),
              statesDropdown(),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Enter Organization Name',
                    'Organization Name', organizationnameController),
                controller: organizationnameController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter details (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Organization info',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              organizationinfoController.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: organizationinfoController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration('Enter Tournament Name',
                    'Tournament Name', tournamentsdetailsController),
                controller: tournamentnameController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration('Enter Start Date',
                          'Start Date', startdateController),
                      controller: startdateController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'Value is empty';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: inputDecoration(
                          'Enter End Date', 'End Date', enddateController),
                      keyboardType: TextInputType.number,
                      controller: enddateController,
                      validator: (value) {
                        if (value.isEmpty) return 'Value is empty';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Enter image url ', 'Image1', image1Controller),
                controller: image1Controller,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Enter image url', 'Image2', image2Controller),
                controller: image2Controller,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: inputDecoration(
                    'Enter image url', 'Image3', image2Controller),
                controller: image3Controller,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter  details (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Tournaments details',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              tournamentsdetailsController.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: tournamentsdetailsController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter  Rules (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Rules',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              rulesController.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: rulesController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter  Prize Pool (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Prize Pool',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              prizepoolController.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: prizepoolController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText:
                        'Enter  Contact Info and venue (Html or Normal Text)',
                    border: OutlineInputBorder(),
                    labelText: 'Contact Info and Venue',
                    contentPadding:
                        EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                            icon: Icon(Icons.close, size: 15),
                            onPressed: () {
                              contactvenueController.clear();
                            }),
                      ),
                    )),
                textAlignVertical: TextAlignVertical.top,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: contactvenueController,
                validator: (value) {
                  if (value.isEmpty) return 'Value is empty';
                  return null;
                },
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  color: KPrimarycolor,
                  height: 45,
                  child: uploadStarted == true
                      ? Center(
                          child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator()),
                        )
                      // ignore: deprecated_member_use
                      : FlatButton(
                          child: Text(
                            'Upload Tournaments',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            handleSubmit();
                          })),
              SizedBox(
                height: 50,
              ),
            ],
          )),
    );
  }

  Widget statesDropdown() {
    final AdminBloc ab = Provider.of(context, listen: false);
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(30)),
        child: DropdownButtonFormField(
            itemHeight: 50,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                gameSelection = value;
              });
            },
            onSaved: (value) {
              setState(() {
                gameSelection = value;
              });
            },
            value: gameSelection,
            hint: Text('Select games'),
            items: ab.games.map((f) {
              return DropdownMenuItem(
                child: Text(f),
                value: f,
              );
            }).toList()));
  }
}
