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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/widgets/dialogs.dart';
import 'package:epilyon/widgets/office_button.dart';
import 'package:epilyon/pages/ms_login.dart';

// TODO: Rework this with a modern look

class LoginPage extends StatefulWidget
{
  LoginPage({ Key key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  BuildContext _dialogContext;

  void _onConnectPress(BuildContext context)
  {
    showLoadingDialog(
        context,
        title: 'Chargement',
        content: 'Création de la session...',
        onContextUpdate: (ctx) => _dialogContext = ctx
    );

    createSession().then((_) {
      if (_dialogContext == null) {
        return;
      }

      Navigator.pop(_dialogContext);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MSLoginPage(title: "Connexion"))
      );
    }).catchError((e, trace) {
      if (_dialogContext == null) {
        return;
      }

      print('Error during session creation : ' + e.toString());
      print(trace);

      Navigator.pop(_dialogContext);
      showErrorDialog(
        context,
        title: 'Erreur',
        content: 'Impossible de se connecter au serveur : ' + e.toString()
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Bienvenue", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Bienvenue sur Epilyon, une application déstinée aux étudiants de l’EPITA "
                    "de Lyon visant à rendre leur quotidien un peu moins chiant et à les forcer "
                    "à travailler un peu plus.\n\n"
                    "Un compte Office 365 en @epita.fr est requis pour utiliser l’application "
                    "(logique), je ne ferai pas de bétise avec, promis.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: OfficeButton(
                onPressed: () => _onConnectPress(context),
                text: "Se connecter via Office 365",
              ),
            )
          ],
        ),
      ),
    );
  }
}
