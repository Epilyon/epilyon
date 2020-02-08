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
import 'package:epilyon/base.dart';
import 'package:epilyon/data.dart';
import 'package:epilyon/widgets/dialogs.dart';

class RefreshPage extends StatefulWidget
{
  RefreshPage({Key key}) : super(key: key);

  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage>
{
  BuildContext _dialogContext;

  @override
  void initState()
  {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!(await canRefresh())) {
        pushBase(context);
        return;
      }

      showLoadingDialog(
          context,
          title: 'Bienvenue',
          content: "Chargement d'Epilyon...",
          onContextUpdate: (ctx) => _dialogContext = ctx
      );

      refresh().then((_) => fetchData()).catchError((e, trace) async {
        print('Error while doing refresh/fetching data : ' + e.toString());
        print('Considering not logged');
        print(trace);

        await cancelLogin();
      }).whenComplete(() {
        if (_dialogContext == null) {
          Navigator.pop(_dialogContext);
        }

        pushBase(context);
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Container();
  }
}
