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

List<Delegate> get delegates => data.delegates;

Future<String> addDelegate(String email) async {
  var result = await http.post(API_URL + '/delegates/add', headers: {
    'Content-Type': 'application/json',
    'Token': getToken()
  }, body: jsonEncode({ 'email': email }));

  return parseResponse(utf8.decode(result.bodyBytes))['name'];
}

Future<void> removeDelegate(String email) async {
  var result = await http.post(API_URL + '/delegates/remove', headers: {
    'Content-Type': 'application/json',
    'Token': getToken()
  }, body: jsonEncode({ 'email': email }));

  parseResponse(utf8.decode(result.bodyBytes));
}

class Delegate
{
  String name;
  String email;

  Delegate(this.name, this.email);
}