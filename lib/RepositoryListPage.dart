import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_io_sample/RepositoryResponse.dart';
import 'package:http/http.dart' as http;

import 'RepositoryListItem.dart';

class RepositoryListPage extends StatefulWidget {
  @override
  _RepositoryListPageState createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends State<RepositoryListPage> {
  final String _url =
      "https://api.github.com/search/repositories?q=flutter:popular";

  final List<Repository> _list = List();

  String _currentState = "loading";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repositories"),
      ),
      body: SafeArea(
        child: _getView(context),
      ),
    );
  }

  _getView(BuildContext context) {
    switch (_currentState) {
      case "loading":
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      case "success":
        return ListView.builder(
          itemBuilder: (BuildContext context, int position) =>
              RepositoryListItem(_list[position], position),
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
        );
      case "failure":
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    "Something went wrong! Please try again later",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                MaterialButton(
                  color: Colors.orange,
                  onPressed: () => _loadData(),
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        }
    }
    if (_list.isEmpty) {
    } else {}
  }

  _loadData() async {
    setState(() {
      _currentState = "loading";
    });
    try {
      var resp = await http.get(_url);
      RepositoryResponse response =
          RepositoryResponse.fromJson(jsonDecode(resp.body));
      setState(() {
        _list.clear();
        _list.addAll(response.items);
        if (response.items.isNotEmpty) {
          _currentState = "success";
        } else {
          _currentState = "failure";
        }
      });
      print('Response status: ${resp.statusCode}');
      print('Response body: ${resp.body}');
      setState(() {
        _currentState = "success";
      });
    } on Exception catch (e) {
      print("Error: $e");
      setState(() {
        _currentState = "failure";
      });
    }
  }
}
