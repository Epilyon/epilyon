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
import 'package:epilyon/pages/base.dart';
import 'package:epilyon/pages/task/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

import 'package:epilyon/task.dart';
import 'package:epilyon/mimos.dart';
import 'package:epilyon/widgets/card.dart';
import 'package:epilyon/widgets/dialogs.dart';
import 'package:epilyon/pages/manage/add_mimos_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  final bool canAdd;
  final bool canRemove;

  TaskPage({this.canAdd = false, this.canRemove = false, Key? key})
      : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('EEEE dd MMMM');

    var days = Map<String, List<Task>>();

    for (var t in tasks!) {
      var dayStr = dateFormatter.format(t.dueDate!);

      if (!days.containsKey(dayStr)) {
        days[dayStr] = <Task>[];
      }

      days[dayStr]!.add(t);
    }

    var sortedKeys = days.keys.toList();
    sortedKeys.sort(
        (a, b) => dateFormatter.parse(a).compareTo(dateFormatter.parse(b)));

    var cards = <Widget>[];

    cards.add(Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 7.5),
        child: Text("Powered by Epitaf.fr",
            style: TextStyle(
                color: Color(0xFF888888), fontStyle: FontStyle.italic))));

    sortedKeys.forEach((day) {
      var tasks = days[day]!;
      var rows = <TableRow>[];

      for (int i = 0; i < tasks.length; i++) {
        rows.add(TableRow(children: [
          buildEntry(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BasePage(
                      title: tasks[i].title,
                      child: TaskDetailPage(task: tasks[i]));
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(tasks[i].title!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.0)),
                      )),
                  SvgPicture.asset('assets/icons/navigate_next.svg',
                      color: Colors.black, width: 27.5)
                ],
              ))
        ]));
      }

      cards.add(Padding(
        padding: EdgeInsets.only(
            top: 10.0, bottom: (day == sortedKeys.last) ? 30.0 : 7.5),
        child: EpiCard(
            title: day,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 22.5, right: 15.0, bottom: 15.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: FractionColumnWidth(1)},
                children: rows,
              ),
            )),
      ));
    });

    return Center(
      child: Column(
        children: cards,
      ),
    );
  }

  Widget buildEntry({Widget? child, Function()? onTap}) {
    var borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(0.0), bottomRight: Radius.circular(0.0));

    return Material(
      elevation: 0.0,
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          height: 40.0,
          child: child,
        ),
      ),
    );
  }
}
