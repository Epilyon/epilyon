import 'package:epilyon/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/pages/home.dart';
import 'package:epilyon/api.dart';

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
        // TODO: Logging
        controller.loadUrl(API_URL + "/auth/login", headers: {
            "Authorization": "Bearer " + getToken()
        });
    }

    void _onChannelMessage(BuildContext context, JavascriptMessage message)
    {
        if (message.message != 'Close') {
            return;
        }

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
                _dialogContext = context;

                return LoadingDialog(
                    title: Text("Chargement"),
                    content: Text("Obtention de l'utilisateur..."),
                );
            }
        ).whenComplete(() {
            _dialogContext = null;
        });

        login().then((_) {
            if (_dialogContext == null) {
                // TODO: Cancel login or prevent return
                return;
            }

            Navigator.pop(_dialogContext);
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: "Accueil")));
        }).catchError((e) {
            // TODO: Generify ?
            if (_dialogContext == null) {
                return;
            }

            Navigator.pop(_dialogContext);
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: Text("Erreur"),
                    content: Text("Impossible de se connecter au serveur : " + e.toString()),
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
                    name: "Epilyon", onMessageReceived: (message) => _onChannelMessage(context, message)
                )]),
            ),
        );
    }
}