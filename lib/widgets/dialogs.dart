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

void showLoadingDialog(BuildContext context, {
  String title,
  String content,
  Function(BuildContext context) onContextUpdate
})
{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        onContextUpdate(context);

        return LoadingDialog(
          title: Text(title),
          content: Text(content),
        );
      }
  ).whenComplete(() {
    onContextUpdate(null);
  });
}

void showErrorDialog(BuildContext context, { String title, String content })
{
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text("OK :("),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
  );
}

void showConfirmDialog(BuildContext context, {
  String title,
  String content,
  Function() onConfirm,
  String okText = 'Oui',
  String cancelText = 'Annuler'
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(okText),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
          FlatButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
  );
}

class LoadingDialog extends SimpleDialog
{
  LoadingDialog({
    Widget title,
    Widget content
  }) : super(
      title: title,
      children: <Widget>[
        Padding(
          // TODO: TEXT WRAPPING!
          padding: const EdgeInsets.only(left: 32.5, right: 30, top: 12.5, bottom: 8.5),
          child: Row(
            children: <Widget>[
              CircularProgressIndicator(
                value: null,
              ),
              Flexible(child: Padding(
                padding: const EdgeInsets.only(left: 27.5),
                child: content,
              ))
            ],
          ),
        )
      ]
  );
}
