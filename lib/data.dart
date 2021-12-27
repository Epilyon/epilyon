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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:epilyon/api_url.dart';
import 'package:epilyon/api.dart';
import 'package:epilyon/auth.dart';
import 'package:epilyon/delegates.dart';
import 'package:epilyon/mimos.dart';
import 'package:epilyon/mcq.dart';
import 'package:epilyon/task.dart';

class UserData {
  Delegate? admin;
  List<Delegate>? delegates;
  List<MCQ>? mcqHistory;
  List<Mimos>? mimos;
  NextMCQ? nextMcq;
  List<Task>? tasks;

  UserData(
      {this.admin,
      this.delegates,
      this.mcqHistory,
      this.mimos,
      this.nextMcq,
      this.tasks});
}

late UserData data;

DateFormat jsonDateFormat = new DateFormat('yyyy-MM-dd');
DateFormat mimosDateFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

Future<void> testConnection() async {
  await http.get(Uri.parse('http://google.com/'));
}

Future<void> pingServer() async {
  await http.get(Uri.parse(API_URL + '/'));
}

Future<void> fetchData() async {
  var result = await http
      .get(Uri.parse(API_URL + '/data/get'), headers: {'Token': getToken()!});

  data = parseData(parseResponse(utf8.decode(result.bodyBytes))['data']);
  await save();
}

Future<void> forceRefresh() async {
  var result = await http.post(Uri.parse(API_URL + '/data/refresh'),
      headers: {'Token': getToken()!});

  parseResponse(result.body);
}

// TODO: Rework this part SOON

UserData parseData(dynamic data) {
  List<Delegate>? delegates = data['delegates'].map<Delegate>((delegate) {
    return Delegate(delegate['name'], delegate['email']);
  }).toList();

  List<MCQ> mcqs = data['mcq_history'].map<MCQ>((mcq) {
    List<MCQGrade>? grades = mcq['grades']
        .map<MCQGrade>((grade) => MCQGrade(
            grade['subject'],
            grade['points']
                .map((p) => p as double)
                .toList()
                .reduce((a, b) => a + b)))
        .toList();

    return MCQ(jsonDateFormat.parse(mcq['date']), mcq['average'], grades);
  }).toList();

  mcqs.sort((a, b) => -a.date.compareTo(b.date));

  List<Mimos>? mimos = data['mimos']
      .map<Mimos>((mimos) => Mimos(mimos['subject'], mimos['number'],
          mimos['title'], mimosDateFormat.parse(mimos['date'])))
      .toList();

  var next = data['next_mcq'];
  NextMCQ? nextMcq;
  if (next != null) {
    nextMcq = NextMCQ(
        next['skipped'],
        mimosDateFormat.parse(next['at']),
        next['revisions']
            .map<MCQRevision>((revision) => MCQRevision(revision['subject'],
                revision['work'].map<String>((s) => s as String).toList()))
            .toList(),
        next['last_editor']);
  }

  List<Task>? tasks = data['tasks']
      .map<Task>((task) => Task(
          jsonDateFormat.parse(task['created_at']),
          jsonDateFormat.parse(task['updated_at']),
          task['short_id'],
          task['visibility'],
          task['promotion'],
          task['semester'],
          task['region'],
          task['title'],
          task['subject'],
          task['content'],
          jsonDateFormat.parse(task['due_date']),
          task['created_by_login'],
          task['created_by'],
          task['updated_by_login'],
          task['updated_by']))
      .toList();

  return UserData(
      admin: Delegate(data['admin']['name'], data['admin']['email']),
      delegates: delegates,
      mcqHistory: mcqs,
      mimos: mimos,
      nextMcq: nextMcq,
      tasks: tasks);
}

Future<void> load() async {
  await loadUser();

  final prefs = await SharedPreferences.getInstance();

  var admin = Delegate("Inconnu", "...");
  var delegates = <Delegate>[];
  var mcqs = <MCQ>[];
  var mimos = <Mimos>[];
  var tasks = <Task>[];
  NextMCQ nextMcq;

  if (prefs.containsKey('admin')) {
    var json = jsonDecode(prefs.getString('admin')!);
    admin = Delegate(json['name'], json['email']);
  }

  if (prefs.containsKey('delegates')) {
    for (var delegate in prefs.getStringList('delegates')!) {
      var json = jsonDecode(delegate);
      delegates.add(Delegate(json['name'], json['email']));
    }
  }

  if (prefs.containsKey('mcqs')) {
    for (var mcq in prefs.getStringList('mcqs')!) {
      var json = jsonDecode(mcq);

      mcqs.add(MCQ(
          DateTime.fromMicrosecondsSinceEpoch(json['date']),
          json['average'],
          json['grades']
              .map<MCQGrade>((g) => MCQGrade(g['subject'], g['grade']))
              .toList()));
    }
  }

  if (prefs.containsKey('tasks')) {
    for (var task in prefs.getStringList('tasks')!) {
      var json = jsonDecode(task);

      tasks.add(Task(
          jsonDateFormat.parse(json['created_at']),
          jsonDateFormat.parse(json['updated_at']),
          json['short_id'],
          json['visibility'],
          json['promotion'],
          json['semester'],
          json['region'],
          json['title'],
          json['subject'],
          json['content'],
          jsonDateFormat.parse(json['due_date']),
          json['created_by_login'],
          json['created_by'],
          json['updated_by_login'],
          json['updated_by']));
    }
  }

  if (prefs.containsKey('mimos')) {
    for (var m in prefs.getStringList('mimos')!) {
      var json = jsonDecode(m);

      mimos.add(Mimos(json['subject'], json['number'], json['title'],
          mimosDateFormat.parse(json['date'])));
    }
  }

  if (prefs.containsKey('nextMcq')) {
    var json = jsonDecode(prefs.getString("nextMcq")!);

    if (json != null) {
      nextMcq = NextMCQ(
          json['skipped'],
          mimosDateFormat.parse(json['at']),
          json['revisions']
              .map<MCQRevision>((r) => MCQRevision(r['subject'],
                  r['work'].map<String>((s) => s as String).toList()))
              .toList(),
          json['lastEditor']);
    }
  }

  data = UserData(
      admin: admin, delegates: delegates, mcqHistory: mcqs, mimos: mimos);
}

Future<void> save() async {
  await saveUser();

  final prefs = await SharedPreferences.getInstance();

  prefs.setString("admin",
      jsonEncode({'name': data.admin!.name, 'email': data.admin!.email}));

  prefs.setStringList(
      'delegates',
      data.delegates!
          .map((delegate) =>
              jsonEncode({'name': delegate.name, 'email': delegate.email}))
          .toList());

  prefs.setStringList(
      'mcqs',
      data.mcqHistory!
          .map((mcq) => jsonEncode({
                'date': mcq.date.microsecondsSinceEpoch,
                'average': mcq.average,
                'grades': mcq.grades!
                    .map((grade) =>
                        {'subject': grade.subject, 'grade': grade.grade})
                    .toList()
              }))
          .toList());

  prefs.setStringList(
      'tasks',
      data.tasks!
          .map((task) => jsonEncode({
                'created_at': jsonDateFormat.format(task.createdAt!),
                'updated_at': jsonDateFormat.format(task.updatedAt!),
                'short_id': task.shortId,
                'visibility': task.visibility,
                'promotion': task.promotion,
                'semester': task.semester,
                'region': task.region,
                'title': task.title,
                'subject': task.subject,
                'content': task.content,
                'due_date': jsonDateFormat.format(task.dueDate!),
                'created_by_login': task.createdByLogin,
                'created_by': task.createdBy,
                'updated_by_login': task.updatedBy,
                'updated_by': task.updatedByLogin
              }))
          .toList());

  prefs.setStringList(
      'mimos',
      data.mimos!
          .map((mimos) => jsonEncode({
                'subject': mimos.subject,
                'number': mimos.number,
                'title': mimos.title,
                'date': mimosDateFormat.format(mimos.date!)
              }))
          .toList());

  Map<String, Object?>? next;
  if (data.nextMcq != null) {
    next = {
      'skipped': data.nextMcq!.skipped,
      'at': mimosDateFormat.format(data.nextMcq!.at),
      'revisions': data.nextMcq!.revisions!
          .map((r) => {'subject': r.subject, 'work': r.work})
          .toList(),
      'lastEditor': data.nextMcq!.lastEditor
    };
  }

  prefs.setString("nextMcq", jsonEncode(next));
}
