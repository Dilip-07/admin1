import 'package:admin1/Bloc/adminbloc.dart';
import 'package:admin1/Config/config.dart';
import 'package:admin1/Models/game.dart';
import 'package:admin1/Utils/styles.dart';
import 'package:admin1/Utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Games extends StatefulWidget {
  const Games({Key key}) : super(key: key);

  @override
  _GamesState createState() => _GamesState();
}

class _GamesState extends State<Games> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  // ignore: deprecated_member_use
  List<DocumentSnapshot> _snap = new List<DocumentSnapshot>();
  List<GamesModel> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'games';

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => GamesModel.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
      openToast(context, 'No more contents available!');
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  refreshData() {
    setState(() {
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    _getData();
  }

  handleDelete(timestamp1) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(50),
            elevation: 0,
            children: <Widget>[
              Text('Delete?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
              SizedBox(
                height: 10,
              ),
              Text('Want to delete this item from the database?',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                children: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: KPrimarycolor,
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      await ab
                          .deleteContent(timestamp1, collectionName)
                          .then((value) => ab.getGames())
                          .then((value) => ab.decreaseCount('games_count'))
                          .then((value) =>
                              openToast1(context, 'Deleted Successfully'));
                      refreshData();
                      Navigator.pop(context);
                    },
                  ),

                  SizedBox(width: 10),

                  // ignore: deprecated_member_use
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: KPrimarycolor,
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Games',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            Container(
              width: 300,
              height: 40,
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(30)),
              // ignore: deprecated_member_use
              child: FlatButton.icon(
                  onPressed: () {
                    openAddDialog();
                  },
                  icon: Icon(LineIcons.list),
                  label: Text('Add Games')),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: RefreshIndicator(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              controller: controller,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _data.length + 1,
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 10,
              ),
              itemBuilder: (_, int index) {
                if (index < _data.length) {
                  return dataList(_data[index]);
                }
                return Center(
                  child: new Opacity(
                    opacity: _isLoading ? 1.0 : 0.0,
                    child: new SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: new CircularProgressIndicator()),
                  ),
                );
              },
            ),
            onRefresh: () async {
              refreshData();
            },
          ),
        ),
      ],
    );
  }

  Widget dataList(GamesModel d) {
    return Container(
      height: 130,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(d.imageUrl),
              fit: BoxFit.cover)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            d.gamename,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          Spacer(),
          InkWell(
              child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.delete, size: 16, color: Colors.grey[800])),
              onTap: () {
                handleDelete(d.timestamp);
              }),
        ],
      ),
    );
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController gameNameController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  String timestamp;

  Future addGames() async {
    final DocumentReference ref =
        firestore.collection(collectionName).doc(timestamp);
    await ref.set({
      'gamename': gameNameController.text,
      'imageUrl': imageUrlController.text,
      'timestamp': timestamp
    });
  }

  handleAddGames() async {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      await getTimestamp()
          .then((value) => addGames())
          .then(
              (value) => context.read<AdminBloc>().increaseCount('games_count'))
          .then((value) => openToast1(context, 'Added Successfully'))
          .then((value) => ab.getGames());
      refreshData();
      Navigator.pop(context);
    }
  }

  clearTextfields() {
    gameNameController.clear();
    imageUrlController.clear();
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      timestamp = _timestamp;
    });
  }

  openAddDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(100),
            children: <Widget>[
              Text(
                'Add Games to Database',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: inputDecoration(
                            'Enter Game Name', 'Game Name', gameNameController),
                        controller: gameNameController,
                        validator: (value) {
                          if (value.isEmpty) return 'State name is empty';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: inputDecoration(
                            'Enter Image Url', 'Image Url', imageUrlController),
                        controller: imageUrlController,
                        validator: (value) {
                          if (value.isEmpty) return 'Image url is empty';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Row(
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            color: KPrimarycolor,
                            child: Text(
                              'Add Games',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              await handleAddGames();
                              clearTextfields();
                            },
                          ),

                          SizedBox(width: 10),

                          // ignore: deprecated_member_use
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            color: KPrimarycolor,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ))
                    ],
                  ))
            ],
          );
        });
  }
}
