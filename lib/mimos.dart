/*
 * Epilyon, keeping EPITA students organized
 * Copyright (C) 2019-2020 Adrien 'Litarvan' Navratil
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:epilyon/api.dart';
import 'package:epilyon/api_url.dart';
import 'package:epilyon/auth.dart';
import 'package:epilyon/data.dart';

List<Mimos> get mimos => data.mimos;

Future<void> addMimos(Mimos mimos) async {
  print(mimosDateFormat.format(mimos.date));
  var result = await http.post(Uri.parse(API_URL + '/mimos/add'),
      headers: {'Content-Type': 'application/json', 'Token': getToken()},
      body: jsonEncode({
        'subject': mimos.subject,
        'number': mimos.number,
        'title': mimos.title,
        'date': mimosDateFormat.format(mimos.date)
      }));

  parseResponse(utf8.decode(result.bodyBytes));
}

Future<void> removeMimos(String subject, int number) async {
  var result = await http.post(Uri.parse(API_URL + '/mimos/remove'),
      headers: {'Content-Type': 'application/json', 'Token': getToken()},
      body: jsonEncode({'subject': subject, 'number': number}));

  parseResponse(utf8.decode(result.bodyBytes));
}

class Mimos {
  String subject;
  int number;
  String title;
  DateTime date;

  Mimos(this.subject, this.number, this.title, this.date);
}
