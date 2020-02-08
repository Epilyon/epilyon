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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:epilyon/api_url.dart';
import 'package:epilyon/api.dart';

String _token = "";
User _user;

class User
{
  String username;
  String firstName;
  String lastName;
  String email;
  String promo;
  String avatar;

  User(this.username, this.firstName, this.lastName, this.email, this.promo, this.avatar);
}

Future<bool> canRefresh() async
{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') != null;
}

Future<bool> refresh() async
{
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  if (token == null) {
    return false;
  }

  var result = await http.post(API_URL + '/auth/refresh', headers: {
    'Token': token
  });

  var json;
  try {
    json = parseResponse(result.body);
  } catch (e) {
    prefs.remove('token');
    throw e;
  }

  _token = json["token"];
  await setUser(json["user"]);

  return true;
}

Future<void> createSession() async
{
  var result = await http.post(API_URL + '/auth/start');
  _token = parseResponse(result.body)['token'];
}

Future<bool> login() async
{
  var result = await http.post(API_URL + '/auth/end', headers: {
    'Token': getToken()
  });

  var json = parseResponse(result.body);
  await setUser(json['user']);

  return json['first_time'];
}

Future<void> cancelLogin() async
{
  _token = '';
  _user = null;

  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<void> setUser(dynamic user) async
{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', _token);

  _user = User(
      user['username'],
      user['first_name'],
      user['last_name'],
      user['email'],
      user['promo'],
      user['avatar']
  );

  print("Logged in as '" + _user.firstName + " " + _user.lastName + "'");
}

Future<void> logout() async
{
  var result = await http.post(API_URL + '/auth/logout', headers: {
    'Token': getToken()
  });

  parseResponse(result.body);

  _token = '';
  _user = null;

  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

String getToken()
{
  return _token;
}

User getUser()
{
  return _user;
}
