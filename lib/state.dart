import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:epilyon/api.dart';
import 'package:epilyon/auth.dart';

var state = {};

Future<void> fetchState() async {
    var result = await http.post(API_URL + '/state/get', headers: {
        "Authorization": "Bearer " + getToken()
    });

    state = jsonDecode(result.body)['state'];
}
