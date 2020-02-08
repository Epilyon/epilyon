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
import 'package:flutter/scheduler.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/pages/main.dart';
import 'package:epilyon/widgets/dialogs.dart';

class LogoutPage extends StatefulWidget
{
  LogoutPage({Key key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage>
{
  BuildContext _dialogContext;

  @override
  void initState()
  {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      showLoadingDialog(
          context,
          title: 'Déconnexion',
          content: 'Déconnexion en cours...',
          onContextUpdate: (ctx) => _dialogContext = ctx
      );

      logout().catchError((e, trace) {
        print('Error while doing logout : ' + e.toString());
        print(trace);

        showErrorDialog(
          context,
          title: 'Erreur',
          content: "Erreur lors de la déconnexion : " + e.toString()
        );
      }).whenComplete(() {
        if (_dialogContext == null) {
          Navigator.pop(_dialogContext);
        }

        pushMain(context);
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Container();
  }
}
