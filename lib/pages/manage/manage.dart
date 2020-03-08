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
import 'package:epilyon/data.dart';
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
  var notificationController = TextEditingController();

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

  void notifyAllDialog()
  {
    showConfirmDialog(context,
      title: 'Notifier tout le monde ?',
      content: "Voulez vous envoyer à TOUTE LA PROMO une notification avec comme "
          "contenu '${notificationController.text}' ?",
      onConfirm: doNotifyAll,
      okText: 'Envoyer'
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
        print('Error during delegate addition');
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
        print('Error during delegate removal');
        print(err);
      }

      showErrorDialog(this.context,
          title: 'Erreur',
          content: "Impossible de supprimer le délégué  '${delegate.name}'\n$err"
      );
    });
  }

  void doNotifyAll()
  {
    notifyAll(notificationController.text).then((_) {
      notificationController.text = '';
    }).catchError((err) {
      print('Error during notification sending');
      print(err);

      showErrorDialog(this.context,
          title: 'Erreur',
          content: "Impossible d'envoyer la notification\n$err"
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
            isUserAdmin()
                ? 'Administrateur'
                : (isUserDelegate() ? 'Délégué' : 'Rien du tout'),
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.5, bottom: !isUserAdmin() ? 10.0 : 35.0),
            child: Text(
              'de la promo ' + user.promo,
              style: TextStyle(fontSize: 24.0)
            ),
          ),
          !isUserAdmin() ? Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Administrateur  : ' + data.admin.name,
              style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic)
            ),
          ) : Container(),
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
                          isUserAdmin() ? InkWell(
                            child: SvgPicture.asset(
                                'assets/icons/remove_circle.svg',
                                color: Color(0xFF9D0000),
                                height: 20
                            ),
                            onTap: () => removeDelegateDialog(delegate),
                          ) : Container()
                        ],
                      ),
                    )
                  ],
                )).toList(),
              )
          ),
          isUserAdmin() ? Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 65.0, right: 65.0, bottom: 10.0),
            child: EpiButton(
                text: 'Ajouter un délégué',
                onPressed: () => addDelegateDialog()
            ),
          ) : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
            child: EpiCard(
                title: 'Notifier toute la promo',
                bottomPadding: 0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        maxLines: 5,
                        controller: notificationController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
                      child: EpiButton(
                        text: 'Envoyer',
                        onPressed: notifyAllDialog
                      ),
                    )
                  ],
                )
            ),
          )
        ],
      )
    );
  }
}