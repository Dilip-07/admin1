import 'package:admin1/Bloc/adminbloc.dart';
import 'package:admin1/Config/config.dart';
import 'package:admin1/Models/tournament.dart';
import 'package:admin1/Utils/dialog.dart';
import 'package:admin1/Utils/styles.dart';
import 'package:admin1/Widgets/cover_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTournamentpage extends StatefulWidget {
  final Tournamentsmodel tournamentsData;
  UpdateTournamentpage({Key key, @required this.tournamentsData})
      : super(key: key);
  _UpdateTournamentpageState createState() => _UpdateTournamentpageState();
}

class _UpdateTournamentpageState extends State<UpdateTournamentpage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'Tournaments';
  List paths = [];

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
        await updateDatabase();
        setState(() => uploadStarted = false);
        openDialog(context, 'Updated Successfully', '');
      }
    }
  }

  Future updateDatabase() async {
    final DocumentReference ref = firestore
        .collection('Tournaments')
        .doc(widget.tournamentsData.timeStamp);

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
    };
    await ref.update(_tournamentsData);
  }

  initData() {
    Tournamentsmodel d = widget.tournamentsData;
    gameSelection = d.game;
    organizationnameController.text = d.organizationName;
    organizationinfoController.text = d.organizationInfo;
    tournamentnameController.text = d.tournamentsName;
    startdateController.text = d.startDate;
    enddateController.text = d.endDate;
    image1Controller.text = d.image1;
    image2Controller.text = d.image2;
    image3Controller.text = d.image3;
    tournamentsdetailsController.text = d.tournamentsDetail;
    rulesController.text = d.rules;
    prizepoolController.text = d.prizePool;
    contactvenueController.text = d.contactVenue;
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      key: scaffoldKey,
      body: CoverWidget(
        widget: Form(
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
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
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
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
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
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
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
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
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
                      contentPadding: EdgeInsets.only(
                          right: 0, left: 10, top: 15, bottom: 5),
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
      ),
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
