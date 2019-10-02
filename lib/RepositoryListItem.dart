//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_io_sample/RepositoryDetailsPage.dart';
import 'package:flutter_io_sample/utils/HexColor.dart';

import 'RepositoryResponse.dart';

class RepositoryListItem extends StatefulWidget {
  final Repository _repo;
  final int _position;

  RepositoryListItem(this._repo, this._position);

  @override
  _RepositoryListItemState createState() =>
      _RepositoryListItemState(_repo, _position);
}

class _RepositoryListItemState extends State<RepositoryListItem> {
  final Repository _repo;
  final int _position;

  _RepositoryListItemState(this._repo, this._position);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openDetailsPage(context),
      child: Container(
        color: _position % 2 == 0 ? HexColor("#efefef") : Colors.white,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
              child: SizedBox.fromSize(
                size: Size(40, 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56.0),
                  child:
                      /*CachedNetworkImage(
                    imageUrl: _repo.owner.avatarUrl,
                    placeholder: (context, url) =>
                        Image.asset("assets/images/avatar_placeholder.png"),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),*/
                      Image.network(
                    _repo.owner.avatarUrl,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : Center(
                                child: Icon(Icons.person),
                              ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget._repo.fullName,
                        style: Theme.of(context).textTheme.overline.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        widget._repo.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                          ),
                          Text(
                            widget._repo.stargazersCount.toString(),
                            style: Theme.of(context).textTheme.body1,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          Icon(
                            Icons.call_split,
                            color: Colors.green,
                            size: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                          ),
                          Text(
                            widget._repo.forksCount.toString(),
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        widget._repo.language != null
                            ? widget._repo.language
                            : "Unspecified",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: InkWell(
                borderRadius: BorderRadius.circular(24.0),
                onTap: () => _toggleFavorite(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _getFavIcon(),
                ),
              ),
            )
          ],
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
      _repo.isFavorite = !_repo.isFavorite;
    });
  }

  _openDetailsPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RepositoryDetailsPage(_repo)));
  }
}
