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
import 'package:epilyon/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:epilyon/widgets/card.dart';
import 'package:epilyon/data.dart';
import 'package:epilyon/pages/base.dart';
import 'package:epilyon/pages/qcm/qcm_result.dart';

class QCMHistoryPage extends StatefulWidget
{
  QCMHistoryPage({ Key key }) : super(key: key);

  @override
  _QCMHistoryPageState createState() => _QCMHistoryPageState();
}

class _QCMHistoryPageState extends State<QCMHistoryPage>
{
  @override
  Widget build(BuildContext context)
  {
    DateTime now = DateTime.now();
    DateTime firstSemester = DateTime(now.month < 8 ? now.year - 1 : now.year, 9, 1);
    DateTime secondSemester = DateTime(now.month < 8 ? now.year : now.year + 1, 1, 1);

    // TODO: More dynamic way
    var shift = getUser().promo == "2025" ? 0 : 2;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            now.month >= 1 && now.month <= 6
                ? getSemester(2 + shift, secondSemester, now)
                : Container(),
            getSemester(1 + shift, firstSemester, secondSemester)
          ]
        ),
      ),
    );
  }

  Widget getSemester(int num, DateTime from, DateTime to)
  {
    DateFormat format = new DateFormat("dd MMMM", 'fr_FR');

    List<QCM> qcms = data.qcmHistory.where((qcm) {
      return qcm.date.compareTo(from) >= 0 && qcm.date.compareTo(to) < 0;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: EpiCard(
          title: "Semestre n°$num",
          bottomPadding: 10.0,
          child: Column(
            children: qcms.map((qcm) => Column(
              children: <Widget>[
                Divider(
                  height: 0,
                ),
                buildEntry(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return BasePage(
                          title: 'QCM du ' + format.format(qcm.date),
                          child: QCMResultPage(qcm: qcm)
                      );
                    }));
                  },
                  isLast: qcm == qcms[qcms.length - 1],
                  child: Padding(
                    padding: EdgeInsets.only(bottom: qcm == qcms[qcms.length - 1] ? 1.5 : 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(format.format(qcm.date), style: TextStyle(fontSize: 17.0)),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              qcm.average.toStringAsFixed(1),
                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                            ),
                            Text('/20', style: TextStyle(fontSize: 17.0)),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: SvgPicture.asset(
                                'assets/icons/navigate_next.svg',
                                color: Colors.black,
                                width: 27.5,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )).toList(),
          )
      ),
    );
  }

  Widget buildEntry({ Widget child, Function() onTap, bool isLast })
  {
    var borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(isLast ? 3.0 : 0.0),
        bottomRight: Radius.circular(isLast ? 3.0 : 0.0)
    );

    return Material(
      elevation: 0.0,
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          height: isLast ? 41.5 : 40.0,
          child: child,
        ),
      ),
    );
  }
}