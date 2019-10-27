import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:epilyon/api.dart';

var _token = "";
User _user;

class User
{
    int id;
    String name;
    String email;
    String promo;
    String region;

    User(this.id, this.name, this.email, this.promo, this.region);
}

Future<bool> refresh() async
{
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    if (token == null) {
        return false;
    }

    var result = await http.post(API_URL + '/auth/refresh', headers: {
        "Authorization": "Bearer " + token
    });

    var json = jsonDecode(result.body);
    if (json["token"] != null) {
        _token = json["token"];
        prefs.setString("token", _token);

        await login();

        return true;
    }

    return false;
}

Future<void> createSession() async
{
    var result = await http.post(API_URL + '/auth/start'); // TODO: Handle possible error (generic function?)
    _token = jsonDecode(result.body)["token"];
}

Future<void> login() async
{
    var result = await http.post(API_URL + "/auth/end", headers: { // TODO: Handle errors!
        "Authorization": "Bearer " + getToken()
    });

    var content = jsonDecode(result.body);
    _user = User(content["id"], content["name"], content["email"], content["promo"], content["region"]); // TODO: ...

    if (content["id"] != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", _token);
    }
}

Future<bool> logout() async
{
    var result = await http.post(API_URL + "/auth/logout", headers: {
        "Authorization": "Bearer " + getToken()
    });

    bool success = jsonDecode(result.body)["success"] == true;

    if (success) {
        _token = "";
    }

    return success;
}

String getToken()
{
    return _token;
}

User getUser()
{
    return _user;
}