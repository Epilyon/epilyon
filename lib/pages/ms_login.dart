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
import 'package:webview_flutter/webview_flutter.dart';

import 'package:epilyon/base.dart';
import 'package:epilyon/widgets/dialogs.dart';
import 'package:epilyon/data.dart';
import 'package:epilyon/auth.dart';
import 'package:epilyon/api_url.dart';

class MSLoginPage extends StatefulWidget
{
    MSLoginPage({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _MSLoginPageState createState() => _MSLoginPageState();
}

class _MSLoginPageState extends State<MSLoginPage>
{
    BuildContext _dialogContext;

    Future _onWebViewCreated(WebViewController controller) async
    {
        controller.loadUrl(API_URL + "/auth/login", headers: {
            "Token": getToken()
        });
    }

    void _onChannelMessage(BuildContext context, JavascriptMessage message)
    {
        if (message.message != 'Close') {
            return;
        }

        showLoadingDialog(
            context,
            title: 'Chargement',
            content: 'Récupération des informations...',
            onContextUpdate: (ctx) => _dialogContext = ctx
        );

        login().then((_) => fetchData()).then((_) {
            if (_dialogContext == null) {
                // TODO: Cancel login or prevent return
                return;
            }

            Navigator.pop(_dialogContext);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BasePage())
            );
        }).catchError((e, trace) async {
            if (_dialogContext == null) {
                return;
            }

            await cancelLogin();

            Navigator.pop(_dialogContext);
            Navigator.pop(context);

            print('Error during login/data fetching : ' + e.toString());
            print(trace);

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
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: _onWebViewCreated,
                javascriptChannels: Set.from([JavascriptChannel(
                    name: "Epilyon",
                    onMessageReceived: (message) => _onChannelMessage(context, message)
                )]),
            ),
        );
    }
}