import 'package:e1547/posts_page.dart';
import 'package:e1547/tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import 'client.dart';

class Pool {
  Map raw;

  int id;
  String name;
  String description;
  List<int> postIDs = [];
  String creator;

  Pool.fromRaw(this.raw) {
    id = raw['id'];
    name = raw['name'];
    description = raw['description'];
    postIDs.addAll(raw['post_ids'].cast<int>());
    creator = raw['creator_name'];
  }
}

class PoolPreview extends StatelessWidget {
  final Pool pool;
  final VoidCallback onPressed;

  const PoolPreview(
    this.pool, {
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: new Text(
                pool.name.replaceAll('_', ' '),
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(left: 22, top: 8, bottom: 8, right: 12),
            child: Text(
              pool.postIDs.length.toString(),
              style: new TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }

    return new GestureDetector(
        onTap: this.onPressed,
        child: new Card(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              height: 42,
              child: Center(child: title()),
            ),
            () {
              if (pool.description != '') {
                return new Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 8,
                  ),
                  child: new ParsedText(
                    text: pool.description,
                    style: new TextStyle(
                      color: Colors.grey[600],
                    ),
                    parse: <MatchText>[
                      new MatchText(
                        type: ParsedType.CUSTOM,
                        pattern: r'h[1-6].',
                        renderText: ({String str, String pattern}) {
                          String display = '';
                          Map<String, String> map = Map<String, String>();
                          map['display'] = display;
                          map['value'] = display;
                          return map;
                        },
                      ),
                      new MatchText(
                        type: ParsedType.CUSTOM,
                        pattern: r'(\[\[[\S]*\]\])|({{[\S]*}})',
                        style: new TextStyle(
                          color: Colors.blue[400],
                        ),
                        renderText: ({String str, String pattern}) {
                          String display = str;
                          display = display.replaceAll('{{', '');
                          display = display.replaceAll('}}', '');
                          display = display.replaceAll('[[', '');
                          display = display.replaceAll(']]', '');
                          Map<String, String> map = Map<String, String>();
                          map['display'] = display;
                          map['value'] = display;
                          return map;
                        },
                        onTap: (url) {
                          Navigator.of(context)
                              .push(new MaterialPageRoute<Null>(builder: (context) {
                            return new SearchPage(new Tagset.parse(url));
                          }));
                        },
                      ),
                      new MatchText(
                        type: ParsedType.CUSTOM,
                        pattern: r'(pool {1,2}#[0-9]{3,6})',
                        style: new TextStyle(
                          color: Colors.blue[400],
                        ),
                        onTap: (url) async {
                          Pool p = await client.poolById(int.parse(url.split('#')[1]));
                          Navigator.of(context)
                              .push(new MaterialPageRoute<Null>(builder: (context) {
                            return new PoolPage(p);
                          }));
                        }
                      ),
                      new MatchText(
                        type: ParsedType.CUSTOM,
                        pattern: r'(".+":)*https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
                        style: new TextStyle(
                          color: Colors.blue[400],
                        ),
                        renderText: ({String str, String pattern}) {
                          String display;
                          String value;
                          if (str.contains('"')) {
                            display = str.split('"')[1];
                            value = str.split('":')[1];
                          } else {
                            display = str.replaceAll('https://', '');
                            value = str;
                          }
                          Map<String, String> map = Map<String, String>();
                          map['display'] = display;
                          map['value'] = value;
                          return map;
                        },
                        onTap: (url) {
                          urlLauncher.launch(url);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return new Container();
              }
            }(),
          ],
        )));
  }
}