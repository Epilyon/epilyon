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

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:epilyon/api_url.dart';
import 'package:epilyon/api.dart';
import 'package:epilyon/auth.dart';

class UserData
{
  List<QCM> qcmHistory;

  UserData({ this.qcmHistory });
}

// TODO: Save data

UserData data;

Future<void> fetchData() async {
  var result = await http.get(API_URL + '/data/get', headers: {
    'Token': getToken()
  });

  data = parseData(parseResponse(utf8.decode(result.bodyBytes))['data']);
}

// TODO: Refresh button
Future<void> forceRefresh() async {
  var result = await http.post(API_URL + '/data/refresh', headers: {
    'Token': getToken()
  });

  parseResponse(result.body);
}

UserData parseData(dynamic data)
{
  DateFormat format = new DateFormat("yyyy-MM-dd");
  List<QCM> qcms = data['history'].map<QCM>((qcm) {
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

  return UserData(
      qcmHistory: qcms
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