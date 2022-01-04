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

class EpiDropdown extends StatefulWidget
{
  final List<String> values;
  final void Function(String?) onChanged;

  EpiDropdown({ required this.values, required this.onChanged });

  _EpiDropdownState createState() => _EpiDropdownState();
}

class _EpiDropdownState extends State<EpiDropdown>
{
  String? value;

  @override
  Widget build(BuildContext context)
  {
    if (value == null) {
      value = widget.values[0];
    }

    return Container(
        padding: EdgeInsets.only(left: 17.5, right: 2.5),
        decoration: BoxDecoration(
            color: Color(0xFFECECEC),
            border: Border.all(color: Color(0xFFDCDCDC), width: 1.0),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: DropdownButton(
          isDense: true,
          isExpanded: true,
          underline: SizedBox(),
          iconSize: 42.0,
          icon: SvgPicture.asset(
              'assets/icons/arrow_drop_down.svg',
              color: Color(0xFF027CFF),
              height: 42.0,
              allowDrawingOutsideViewBox: true
          ),
          value: value,
          items: widget.values.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (dynamic value) {
            setState(() => this.value = value);
            widget.onChanged(value);
          },
          style: TextStyle(fontSize: 14.0, color: Color(0xFF484848)),
        )
    );
  }
}