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

class EpiButton extends StatelessWidget
{
  final GestureTapCallback onPressed;
  final String text;

  EpiButton({ @required this.onPressed, @required this.text });

  @override
  Widget build(BuildContext context)
  {
    return Material(
      elevation: 0.0,
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: Ink(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}