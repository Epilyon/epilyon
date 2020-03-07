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

import 'package:epilyon/delegates.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:epilyon/api_url.dart';
import 'package:epilyon/api.dart';
import 'package:epilyon/auth.dart';

class UserData
{
  Delegate admin;
  List<Delegate> delegates;
  List<QCM> qcmHistory;

  UserData({ this.admin, this.delegates, this.qcmHistory });
}

UserData data;

Future<void> testConnection() async {
  await http.get('http://google.com/');
}

Future<void> pingServer() async {
  await http.get(API_URL + '/');
}

Future<void> fetchData() async {
  var result = await http.get(API_URL + '/data/get', headers: {
    'Token': getToken()
  });

  data = parseData(parseResponse(utf8.decode(result.bodyBytes))['data']);
  await save();
}

Future<void> forceRefresh() async {
  var result = await http.post(API_URL + '/data/refresh', headers: {
    'Token': getToken()
  });

  parseResponse(result.body);
}

UserData parseData(dynamic data)
{
  DateFormat format = new DateFormat('yyyy-MM-dd');
  List<QCM> qcms = data['qcm_history'].map<QCM>((qcm) {
    List<QCMGrade> grades = qcm['grades'].map<QCMGrade>((grade) => QCMGrade(
        grade['subject'],
        grade['points']
            .map((p) => p as double)
            .toList()
            .reduce((a, b) => a + b)
    )).toList();

    if (grades.length == 7 && grades[0].subject == 'Élec.') {
      grades.insert(6, grades.removeAt(0));
      grades.insert(6, grades.removeAt(0));
    }

    return QCM(
        format.parse(qcm['date']),
        qcm['average'],
        grades
    );
  }).toList();

  qcms.sort((a, b) => -a.date.compareTo(b.date));

  List<Delegate> delegates = data['delegates'].map<Delegate>((delegate) {
    return Delegate(delegate['name'], delegate['email']);
  }).toList();

  return UserData(
      admin: Delegate(data['admin']['name'], data['admin']['email']),
      qcmHistory: qcms,
      delegates: delegates
  );
}

class QCM
{
  DateTime date;
  double average;
  List<QCMGrade> grades;

  QCM(this.date, this.average, this.grades);
}

class QCMGrade
{
  String subject;
  double grade;

  QCMGrade(this.subject, this.grade);
}

Future<void> load() async
{
  await loadUser();

  final prefs = await SharedPreferences.getInstance();

  var admin = Delegate("Inconnu", "...");
  var delegates = <Delegate>[];
  var qcms = <QCM>[];

  if (prefs.containsKey('delegates')) {
    for (var delegate in prefs.getStringList('delegates')) {
      var json = jsonDecode(delegate);
      delegates.add(Delegate(json['name'], json['email']));
    }
  }

  if (prefs.containsKey('qcms')) {
    for (var qcm in prefs.getStringList('qcms')) {
      var json = jsonDecode(qcm);

      qcms.add(QCM(
          DateTime.fromMicrosecondsSinceEpoch(json['date']),
          json['average'],
          json['grades'].map<QCMGrade>((g) => QCMGrade(g['subject'], g['grade'])).toList()
      ));
    }
  }

  if (prefs.containsKey('admin')) {
    var json = jsonDecode(prefs.getString('admin'));
    admin = Delegate(json['name'], json['email']);
  }

  data = UserData(
    admin: admin,
    qcmHistory: qcms,
    delegates: delegates
  );
}

Future<void> save() async
{
  await saveUser();

  final prefs = await SharedPreferences.getInstance();

  prefs.setString("admin", jsonEncode({ 'name': data.admin.name, 'email': data.admin.email }));

  prefs.setStringList('delegates', data.delegates.map((delegate) => jsonEncode({
    'name': delegate.name,
    'email': delegate.email
  })).toList());
  
  prefs.setStringList('qcms', data.qcmHistory.map((qcm) => jsonEncode({
    'date': qcm.date.microsecondsSinceEpoch,
    'average': qcm.average,
    'grades': qcm.grades.map((grade) => {
      'subject': grade.subject,
      'grade': grade.grade
    }).toList()
  })).toList());
}