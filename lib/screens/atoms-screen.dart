import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../atom.dart';

Future<Atoms> fetchAtoms() async {

  final response =
  await http.get('http://192.168.50.77:7788/api/atoms/30?offset=0');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    var atoms = json.decode(response.body);
    return Atoms.fromJson(atoms);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<int>> fakeRequest(int from, int to) async {
  return Future.delayed(Duration(seconds: 2), () {
    return List.generate(to - from, (i) => i + from);
  });
}

class AtomsPage extends StatefulWidget {
  static String tag = 'atoms-page';
  AtomsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AtomsState createState() => new AtomsState();
}

class AtomsState extends State<AtomsPage> {
  List<Atom> items = List();
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    debugPrint('debug init');
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    debugPrint('Hihihi->');
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<Atom> newEntries = (await fetchAtoms()).items; //returns empty list
      if (newEntries.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge -offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        items.addAll(newEntries);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Infinite ListView"),
      ),
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return ListTile(title: new Text(items[index].title));
          }
        },
        controller: _scrollController,
      ),
    );
  }
}
