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
import 'package:intl/intl.dart';

import 'package:epilyon/widgets/card.dart';
import 'package:epilyon/data.dart';
import 'package:epilyon/mcq.dart';

class MCQResultPage extends StatefulWidget
{
  final MCQ mcq;

  MCQResultPage({ Key key, this.mcq }) : super(key: key);

  @override
  _MCQResultPageState createState() => _MCQResultPageState();
}

class _MCQResultPageState extends State<MCQResultPage>
{
  Color greenGrade = Color(0xFF04C800);
  Color redGrade = Color(0xFFD90000);

  @override
  Widget build(BuildContext context)
  {
    if (widget.mcq == null && data.mcqHistory.length == 0) {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Aucun résultat de QCM",
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              ),
            ]
        ),
      );
    }

    MCQ mcq = widget.mcq != null ? widget.mcq : data.mcqHistory[0];
    MCQ previous;

    for (int i = 0; i < data.mcqHistory.length; i++) {
      if (data.mcqHistory[i] == mcq) {
        if (i + 1 < data.mcqHistory.length) {
          previous = data.mcqHistory[i + 1];
        }

        break;
      }
    }

    DateFormat format = new DateFormat("dd MMMM yyyy", 'fr_FR');

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Text(
              'QCM du ' + format.format(mcq.date),
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                mcq.average.toStringAsFixed(1) + '/20',
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Coefficienté',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            previous == null ? Container()  : Padding(
              padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  compare(mcq.average, previous.average),
                  Text('par rapport au précédent', style: TextStyle(fontSize: 18.0))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.5),
              child: EpiCard(
                  title: 'Notes par matières',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 10.0, right: 22.5),
                    child: Column(
                      children: mcq.grades.map<Widget>((grade) {
                        MCQGrade last = previous == null
                            ? null
                            : previous.grades.firstWhere((g) => grade.subject == g.subject);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                grade.subject,
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: <Widget>[
                                  previous == null ? Container() : Padding(
                                    padding: EdgeInsets.only(
                                        right: grade.grade == 10.0
                                            ? 4.0
                                            : (grade.grade < 0.0 ? 8.25 : 12.75)
                                    ),
                                    child: compare(grade.grade, last.grade),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        grade.grade.toStringAsFixed(1),
                                        style: TextStyle(
                                            color: grade.grade == 10.0
                                                ? greenGrade
                                                : (grade.grade <= 0.0 ? redGrade : null),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text('/10', style: TextStyle(fontSize: 17))
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget compare(double a, double b)
  {
    String sign = a < b ? '- ' : '+';
    String grade = (a - b).abs().toStringAsFixed(1);
    Color color = a > b ? greenGrade : (a < b ? redGrade : Colors.black);

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text("($sign$grade)", style: TextStyle(fontSize: 18.0, color: color)),
    );
  }
}