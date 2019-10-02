//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_io_sample/RepositoryResponse.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryDetailsPage extends StatelessWidget {
  final Repository _repo;

  RepositoryDetailsPage(this._repo);

  @override
  Widget build(BuildContext context) {
    return RepositoryDetails(_repo);
  }
}

class RepositoryDetails extends StatefulWidget {
  final Repository _repo;

  RepositoryDetails(this._repo);

  @override
  _RepositoryDetailsState createState() => _RepositoryDetailsState(_repo);
}

class _RepositoryDetailsState extends State<RepositoryDetails> {
  final Repository _repo;

  _RepositoryDetailsState(this._repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._repo.name),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox.fromSize(
                      size: Size(80, 80),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(56.0),
                        child:
                            /*CachedNetworkImage(
                          imageUrl: _repo.owner.avatarUrl,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/avatar_placeholder.png"),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),*/
                            Image.network(
                          _repo.owner.avatarUrl,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32.0),
                      onTap: () => _toggleFavorite(),
                      child: _getFavIcon(),
                    ),
                  ),
                ],
              ),
              Text(
                widget._repo.fullName,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                widget._repo.description,
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.star, color: Colors.amber, size: 18.0),
                  SizedBox(width: 3.0),
                  Text(widget._repo.stargazersCount.toString(),
                      style: Theme.of(context).textTheme.subhead),
                  SizedBox(width: 16.0),
                  Icon(Icons.call_split, color: Colors.green, size: 18.0),
                  SizedBox(width: 3.0),
                  Text(widget._repo.forksCount.toString(),
                      style: Theme.of(context).textTheme.subhead),
                  SizedBox(width: 16.0),
                  Icon(Icons.whatshot, color: Colors.red, size: 18.0),
                  SizedBox(width: 3.0),
                  Text(widget._repo.openIssuesCount.toString(),
                      style: Theme.of(context).textTheme.subhead),
                  SizedBox(width: 16.0),
                  Icon(Icons.score, color: Colors.blue, size: 18.0),
                  SizedBox(width: 3.0),
                  Text(widget._repo.score.toInt().toString(),
                      style: Theme.of(context).textTheme.subhead),
                ],
              ),
              SizedBox(height: 16.0),
              Detail("Language", _repo.language),
              SizedBox(height: 16.0),
              Detail("License", _repo.license?.name ?? "None"),
              SizedBox(height: 16.0),
              Detail("Default Branch", _repo.defaultBranch),
              SizedBox(height: 16.0),
              Detail("Created Date", _getDate(_repo.createdAt)),
              Flexible(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(32.0),
                          onTap: () => _shareRepo(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              size: 30.0,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        InkWell(
                          borderRadius: BorderRadius.circular(32.0),
                          onTap: () => _openRepo(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.open_in_browser,
                                size: 30.0, color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getFavIcon() {
    if (widget._repo.isFavorite) {
      return Icon(Icons.favorite, color: Colors.red);
    } else {
      return Icon(Icons.favorite_border, color: Colors.red);
    }
  }

  _toggleFavorite() {
    setState(() {
      widget._repo.isFavorite = !widget._repo.isFavorite;
    });
  }

  String _getDate(String createdAt) {
    var now = DateTime.parse(createdAt);
    var formatter = new DateFormat('d MMMM yyyy');
    return formatter.format(now);
  }

  _shareRepo() async {
    print("Sharing repo");
    Share.share(_repo.htmlUrl);
  }

  _openRepo() async {
    print("Opening the url in browser");
    if (await canLaunch(_repo.htmlUrl)) {
      await launch(_repo.htmlUrl);
    } else {
      throw 'Could not launch $_repo.htmlUrl';
    }
  }
}

class Detail extends StatelessWidget {
  final String _title;
  final String _value;

  Detail(this._title, this._value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _title,
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.blue, fontSize: 16.0),
        ),
        Text(
          _value ?? "Unspecified",
          style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 18.0),
        )
      ],
    );
  }
}
