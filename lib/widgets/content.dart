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
import 'package:epilyon/widgets/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/data.dart';
import 'package:epilyon/pages/ms_login.dart';
import 'package:epilyon/widgets/dialogs.dart';

class EpiContent extends StatefulWidget
{
  final Widget child;
  final bool fixed;
  final bool doRefresh;

  EpiContent({ this.child, this.fixed, this.doRefresh = false });

  @override
  _EpiContentState createState() => _EpiContentState();
}

class _EpiContentState extends State<EpiContent>
{
  BuildContext _dialogContext;

  @override
  void initState()
  {
    super.initState();

    if (widget.doRefresh) {
      SchedulerBinding.instance.addPostFrameCallback((_) => doRefresh());
    }
  }

  Future<void> doRefresh() async
  {
    var snack = Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Reconnexion...'))
    );

    bool internet = true;
    try {
      await testConnection();
      internet = false;
      await pingServer();
    } catch (e) {
      print('Error while pinging the server : ' + e.toString());

      snack.close();
      snack = Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
                internet
                    ? 'Mode hors-connexion'
                    : 'Serveur hors-ligne'
            ),
            duration: Duration(days: 10),
            action: SnackBarAction(
              label: 'Rééssayer',
              onPressed: () {
                snack.close();
                Future.delayed(Duration(milliseconds: 500), doRefresh);
              },
            ),
          )
      );

      return;
    }

    refresh()
        .then((_) => fetchData())
        .then((_) {
          snack.close();
          AppBuilder.of(context).rebuild();
        }).catchError((e, trace) async {
          print('Error while doing refresh/fetching data : ' + e.toString());
          print('Considering not logged');
          print(trace);

          snack.close();
          snack = Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Vous avez été déconnecté'),
                duration: Duration(days: 10),
                action: SnackBarAction(
                  label: 'Se reconnecter',
                  onPressed: () {
                    snack.close();
                    doLogin();
                  },
                ),
              )
          );
        });
  }

  void doLogin()
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
    return widget.fixed ? widget.child : SingleChildScrollView(
      child: widget.child,
    );
  }
}