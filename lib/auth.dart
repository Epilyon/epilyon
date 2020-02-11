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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:epilyon/api_url.dart';
import 'package:epilyon/api.dart';
import 'package:epilyon/firebase.dart';

String _token = "";
User _user;
bool _logged = false;

// TODO: Merge user saving and token saving, move saving in data.dart, save avatar

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
  return !_logged && prefs.getString('token') != null && prefs.containsKey("user");
}

Future<bool> refresh() async
{
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  if (token == null) {
    return false;
  }

  print('Loading token : ' + token);

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

  _logged = true;
  return true;
}

Future<void> createSession() async
{
  var deviceToken = await getDeviceToken();
  var result = await http.post(API_URL + '/auth/start', headers: {
    'Content-Type': 'application/json'
  }, body: '{"device_token": "$deviceToken"}');

  _token = parseResponse(result.body)['token'];
}

Future<bool> login() async
{
  var result = await http.post(API_URL + '/auth/end', headers: {
    'Token': getToken()
  });

  var json = parseResponse(result.body);
  await setUser(json['user']);

  _logged = true;
  return json['first_time'];
}

Future<void> cancelLogin() async
{
  _token = '';
  _user = null;
  _logged = false;

  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<void> setUser(dynamic user) async
{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', _token);
  print('Saving token : ' + _token);

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
  _logged = false;

  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<void> loadUser() async
{
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('user')) {
    return;
  }

  _token = prefs.getString("token");
  setUser(jsonDecode(prefs.getString('user')));
}

Future<void> saveUser() async
{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user", jsonEncode({
    'username': _user.username,
    'first_name': _user.firstName,
    'last_name': _user.lastName,
    'email': _user.email,
    'promo': _user.promo,
    'avatar': _user.avatar
  }));
}

bool isLogged()
{
  return _logged;
}

String getToken()
{
  return _token;
}

User getUser()
{
  return _user;
}
