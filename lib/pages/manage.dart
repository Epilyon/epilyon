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

import 'package:epilyon/auth.dart';
import 'package:epilyon/delegates.dart';
import 'package:epilyon/widgets/button.dart';
import 'package:epilyon/widgets/card.dart';
import 'package:epilyon/widgets/dialogs.dart';

class ManagePage extends StatefulWidget
{
  ManagePage({ Key key }) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage>
{
  void addDelegateDialog()
  {
    showInputDialog(context,
      title: 'Ajouter un délégué',
      content: 'E-Mail du délégué à ajouter :',
      okText: 'Ajouter',
      onConfirm: doAddDelegate,
      email: true
    );
  }

  void removeDelegateDialog(Delegate delegate)
  {
    showConfirmDialog(context,
      title: 'Supprimer le délégué ?',
      content: "Voulez-vous vraiment enlever '${delegate.name}' des délégués ?",
      onConfirm: () => doRemoveDelegate(delegate),
      okText: 'Supprimer'
    );
  }

  void doAddDelegate(BuildContext context, String email)
  {
    addDelegate(email).then((name) {
      Navigator.of(context).pop();

      if (!delegates.any((del) => del.email == email)) {
        setState(() {
          delegates.add(new Delegate(name, email));
        });
      }
    }).catchError((err) {
      if (!(err is String)) {
          print(err);
      }

      showErrorDialog(this.context,
          title: 'Erreur',
          content: "Impossible d'ajouter le délégué à l'email '$email'\n$err"
      );
    });
  }

  void doRemoveDelegate(Delegate delegate)
  {
    removeDelegate(delegate.email).then((_) {
      setState(() {
        delegates.removeWhere((del) => del.email == delegate.email);
      });
    }).catchError((err) {
      if (!(err is String)) {
        print(err);
      }

      showErrorDialog(this.context,
          title: 'Erreur',
          content: "Impossible de supprimer le délégué  '${delegate.name}'\n$err"
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = getUser();

    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 35.0, bottom: 2.5),
            child: Text('Vous êtes', style: TextStyle(fontSize: 30.0)),
          ),
          Text(
            user.admin
                ? 'Administrateur'
                : (user.delegate ? 'Délégué' : 'Rien du tout'),
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.5, bottom: 35.0),
            child: Text(
              'de la promo ' + user.promo,
              style: TextStyle(fontSize: 24.0)
            ),
          ),
          EpiCard(
              title: 'Délégués',
              bottomPadding: 10.0,
              child: Column(
                children: delegates.map<Widget>((delegate) => Column(
                  children: <Widget>[
                    Divider(
                        height: 0
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9.5, horizontal: 12.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(delegate.name, style: TextStyle(fontSize: 16.0),),
                          InkWell(
                            child: SvgPicture.asset(
                                'assets/icons/remove_circle.svg',
                                color: Color(0xFFAA0000),
                                height: 20
                            ),
                            onTap: () => removeDelegateDialog(delegate),
                          )
                        ],
                      ),
                    )
                  ],
                )).toList(),
              )
          ),
          user.admin ? Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 65.0, right: 65.0),
            child: EpiButton(
                text: 'Ajouter un délégué',
                onPressed: () => addDelegateDialog()
            ),
          ) : Container()
        ],
      )
    );
  }
}