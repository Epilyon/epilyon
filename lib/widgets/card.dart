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

class EpiCard extends StatelessWidget
{
  final String title;
  final Widget child;
  final bool fullSize;

  EpiCard({ @required this.title, @required this.child, this.fullSize = true });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: fullSize ? MediaQuery.of(context).size.width - 30.0 : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 8.0,
            color: Color.fromRGBO(116, 129, 141, 0.1)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 13.5, top: 11.5, bottom: 12.5),
            child: Text(this.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
          ),
          child
        ],
      ),
    );
  }
}