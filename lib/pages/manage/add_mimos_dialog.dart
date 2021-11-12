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

import 'package:epilyon/mimos.dart';
import 'package:epilyon/widgets/button.dart';
import 'package:epilyon/widgets/dropdown.dart';
import 'package:epilyon/widgets/text_form_field.dart';

class AddMimosDialog extends StatefulWidget {
  final void Function(Mimos) callback;

  AddMimosDialog(this.callback, {Key? key}) : super(key: key);

  @override
  _AddMimosDialogState createState() => _AddMimosDialogState();
}

class _AddMimosDialogState extends State<AddMimosDialog> {
  final _formKey = GlobalKey<FormState>();

  var subject = 'Algo';
  var numberController = TextEditingController();
  var titleController = TextEditingController();
  var dateController = TextEditingController();

  DateTime? date;

  void submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();

      widget.callback(Mimos(subject, int.parse(numberController.text),
          titleController.text, date));
    }
  }

  void dateDialog() async {
    var now = DateTime.now();
    var last = new DateTime(now.year + (now.month > 8 ? 1 : 0), 7, 7);

    var date = await showDatePicker(
        context: context, firstDate: now, initialDate: now, lastDate: last);

    if (date == null) {
      return;
    }

    setState(() {
      dateController.text = date.toString().split(' ')[0];
      this.date = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Ajouter un MiMos'),
      titlePadding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 12.5),
      contentPadding:
          EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0, top: 7.5),
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Matière',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                  ),
                  EpiDropdown(
                    values: ['Algo', 'Maths', 'Physique', 'Élec'],
                    onChanged: (value) => subject = value!,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 15.0),
                    child: Text(
                      'Numéro',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: EpiTextFormField(
                      controller: numberController,
                      number: true,
                      callback: submit,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                    child: Text(
                      'Titre',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: EpiTextFormField(
                      controller: titleController,
                      callback: submit,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                    child: Text(
                      'Pour le',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22.5),
                    child: EpiTextFormField(
                      controller: dateController,
                      readonly: true,
                      onTap: dateDialog,
                    ),
                  ),
                  EpiButton(text: 'Ajouter', onPressed: submit)
                ]))
      ],
    );
  }
}
