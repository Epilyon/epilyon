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
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

import 'package:epilyon/mimos.dart';
import 'package:epilyon/widgets/button.dart';
import 'package:epilyon/widgets/card.dart';
import 'package:epilyon/widgets/dialogs.dart';
import 'package:epilyon/pages/manage/add_mimos_dialog.dart';

class MimosPage extends StatefulWidget
{
  final bool canAdd;
  final bool canRemove;

  MimosPage({ this.canAdd = false, this.canRemove = false, Key key }) : super(key: key);

  @override
  _MimosPageState createState() => _MimosPageState();
}

class _MimosPageState extends State<MimosPage>
{
  void showMimosDialog()
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddMimosDialog(doAddMimos)
    );
  }

  void showRemoveDialog(Mimos mimos)
  {
    showConfirmDialog(context,
        title: 'Supprimer le MiMos ?',
        content: "Voulez-vous vraiment supprimer le Mimos "
            "[${mimos.subject} : ${mimos.number} - ${mimos.title}] ?",
        okText: 'Supprimer',
        onConfirm: () => doRemoveMimos(mimos)
    );
  }

  void doAddMimos(Mimos m) {
    addMimos(m).then((_) => setState(() {
      mimos.add(m);
    })).catchError((err) {
      if (!(err is String)) {
        print('Error while adding mimos');
        print(err);
      }

      return showErrorDialog(context,
          title: 'Erreur',
          content: "Impossible d'ajouter le MiMos : $err"
      );
    });
  }

  void doRemoveMimos(Mimos m)
  {
    removeMimos(m.subject, m.number).then((_) => setState(() {
      mimos.removeWhere((mm) => mm.number == m.number && mm.subject == m.subject);
    })).catchError((err) {
      if (!(err is String)) {
        print('Error while removing mimos');
        print(err);
      }

      return showErrorDialog(context,
          title: 'Erreur',
          content: "Impossible de supprimer le MiMos : $err"
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {
    var weeks = Map<String, Map<String, List<Mimos>>>();

    for (var m in mimos) {
      var week = new DateTime(m.date.year, m.date.month, m.date.day);
      week = week.subtract(new Duration(days: m.date.weekday - 1));

      var weekStr = (week.day < 10 ? '0' : '')
          + week.day.toString()
          + '/'
          + (week.month < 10 ? '0' : '')
          + week.month.toString();

      if (!weeks.containsKey(weekStr)) {
        weeks[weekStr] = Map<String, List<Mimos>>();
        for (var sub in ['Algo', 'Maths', 'Physique', 'Élec']) {
          weeks[weekStr][sub] = <Mimos>[];
        }
      }

      if (!weeks[weekStr].containsKey(m.subject)) {
        weeks[weekStr][m.subject] = <Mimos>[];
      }

      weeks[weekStr][m.subject].add(m);
    }

    var cards = <Widget>[];
    weeks.forEach((week, subjects) {
      var rows = <TableRow>[];

      subjects.forEach((subject, mimos) {
        mimos.sort((a, b) => a.number.compareTo(b.number));

        for (int i = 0; i < mimos.length; i++) {
          rows.add(TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    i == 0 ? subject : '',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 19.0
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                        mimos[i].number.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text('-'),
                    ),
                    Flexible(
                      child: TextOneLine(
                        mimos[i].title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 17.0
                        ),
                      ),
                    )
                  ],
                ),
                widget.canRemove ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: SvgPicture.asset(
                          'assets/icons/remove_circle.svg',
                          color: Color(0xFF9D0000),
                          height: 20
                      ),
                      onTap: () => showRemoveDialog(mimos[i]),
                    ),
                  ],
                ) : Container()
              ]
          ));
        }
      });

      cards.add(Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 7.5),
        child: EpiCard(
            title: 'Semaine du ' + week,
            child: Padding(
              padding: const EdgeInsets.only(left: 22.5, right: 15.0, bottom: 15.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FractionColumnWidth(0.3),
                  1: FractionColumnWidth(widget.canRemove ? 0.6 : 0.7),
                  2: FractionColumnWidth(widget.canRemove ? 0.1 : 0.0)
                },
                children: rows,
              ),
            )
        ),
      ));
    });

    if (widget.canAdd) {
      cards.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 75.0, vertical: 12.5),
        child: EpiButton(
          text: 'Ajouter',
          onPressed: showMimosDialog,
        ),
      ));
    }

    return Center(
      child: Column(
        children: cards,
      ),
    );
  }
}