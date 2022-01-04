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
import 'package:flutter/services.dart';

void showLoadingDialog(BuildContext context, {
  String? title,
  String? content,
  Function(BuildContext? context)? onContextUpdate
})
{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        onContextUpdate!(context);

        return LoadingDialog(
          title: Text(title!),
          content: Text(content!),
        );
      }
  ).whenComplete(() {
    onContextUpdate!(null);
  });
}

void showErrorDialog(BuildContext context, { String? title, String? content })
{
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title!),
        content: Text(content!),
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
  String? title,
  String? content,
  void Function()? onConfirm,
  String okText = 'Oui',
  String cancelText = 'Annuler'
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title!),
        content: Text(content!),
        actions: <Widget>[
          FlatButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(okText),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm!();
            },
          )
        ],
      )
  );
}

void showInputDialog(BuildContext context, {
  String? title,
  String? content,
  void Function(BuildContext, String)? onConfirm,
  String? okText,
  String cancelText = 'Annuler',
  bool email = false
}) {
  final controller = TextEditingController(text: email ? '@epita.fr' : '');
  controller.selection = new TextSelection(baseOffset: 0, extentOffset: 0);

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(content!),
          TextField(
            keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
            autofocus: true,
            controller: controller,
            autocorrect: !email,
            enableSuggestions: !email,
            inputFormatters: email ? [
              TextInputFormatter.withFunction(emailFormatter)
            ] : [],
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(cancelText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(okText!),
          onPressed: () {
            onConfirm!(context, controller.text);
          },
        )
      ],
    )
  );
}

class LoadingDialog extends SimpleDialog
{
  LoadingDialog({
    Widget? title,
    Widget? content
  }) : super(
      title: title,
      children: <Widget>[
        Padding(
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

TextEditingValue emailFormatter(TextEditingValue oldValue, TextEditingValue newValue)
{
  var newVal = newValue.text;
  var lenWithoutSuffix = newVal.length - '@epita.fr'.length;

  if (newVal.endsWith('@epita.fr@epita.fr')) {
    newVal = newVal.substring(0, lenWithoutSuffix);
    lenWithoutSuffix -= '@epita.fr'.length;
  }

  var hasSuffix = newVal.endsWith('@epita.fr');
  var hasOtherAt = newVal.substring(0, lenWithoutSuffix).contains('@');
  var isNewValid = hasSuffix && !hasOtherAt;

  var sel = newValue.selection;
  if (sel.baseOffset > lenWithoutSuffix) {
    sel = new TextSelection(
        baseOffset: lenWithoutSuffix - (isNewValid ? 0 : 1),
        extentOffset: sel.extentOffset
            - (sel.baseOffset - lenWithoutSuffix)
            - (isNewValid ? 0 : 1),
        affinity: sel.affinity
    );
  }

  if (isNewValid) {
    return new TextEditingValue(
        text: newVal,
        composing: newValue.composing,
        selection: sel
    );
  }

  return new TextEditingValue(
      text: oldValue.text,
      composing: oldValue.composing,
      selection: sel
  );
}