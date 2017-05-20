// e1547: A mobile app for browsing e926.net and friends.
// Copyright (C) 2017 perlatus <perlatus@e1547.email.vczf.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/material.dart' show MaterialApp, ThemeData;
import 'package:flutter/widgets.dart' as widgets;
import 'package:logging/logging.dart' show Level, Logger, LogRecord;

import 'posts_page.dart' show PostsPage;
import 'settings_page.dart' show SettingsPage;
import 'vars.dart' as vars;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.object == null) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      print('${rec.level.name}: ${rec.time}: ${rec.message}: ${rec.object}');
    }
  });

  widgets.runApp(new MaterialApp(
      title: vars.APP_NAME,
      theme: new ThemeData.dark(),
      initialRoute: '/posts',
      routes: <String, widgets.WidgetBuilder>{
        '/posts': (ctx) => new PostsPage(),
        '/settings': (ctx) => new SettingsPage(),
      }));
}
