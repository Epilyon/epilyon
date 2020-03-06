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
import 'package:flutter_svg/flutter_svg.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/widgets/dialogs.dart';
import 'package:epilyon/pages/ms_login.dart';

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
    // TODO: Find a way to generify
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
          MaterialPageRoute(builder: (context) => MSLoginPage())
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
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  image: AssetImage("assets/images/login_background.jpg")
              )
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(153)
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 70.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0, bottom: 15.0),
                            child: SvgPicture.asset(
                              'assets/icons/epilyon.svg',
                              width: 75.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Epilyon',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
                      child: buildOfficeButton(context),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget buildOfficeButton(BuildContext context)
  {
    return Material(
      elevation: 0.0,
      color: Color(0xFF0070E8),
      borderRadius: BorderRadius.circular(4.0),
      child: InkWell(
        onTap: () => _onConnectPress(context),
        child: Ink(
          height: 50.0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SvgPicture.asset(
                      'assets/icons/office.svg',
                      width: 21.0,
                      height: 21.0
                  ),
                ),
                Text(
                  'Se connecter via Office 365',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
