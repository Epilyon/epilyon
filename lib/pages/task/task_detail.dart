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
import 'package:epilyon/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? task;

  TaskDetailPage({Key? key, this.task}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.task == null) {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Erreur 404",
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              ),
            ]),
      );
    }

    Task task = widget.task!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            MarkdownBody(data: task.content!),
            Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 7.5),
                child: Text("Powered by Epitaf.fr",
                    style: TextStyle(
                        color: Color(0xFF888888), fontStyle: FontStyle.italic)))
          ],
        ),
      ),
    );
  }
}
