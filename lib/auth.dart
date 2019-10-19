import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:epilyon/api.dart';

var _token = ""; // TODO: Save it
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
}

String getToken()
{
    return _token;
}

User getUser()
{
    return _user;
}