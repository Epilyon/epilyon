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
    Future _onWebViewCreated(WebViewController controller) async
    {
        // TODO: Logging
        await createSession();

        controller.loadUrl(API_URL + "/auth/login", headers: {
            "Authorization": "Bearer " + getToken()
        });
    }

    void _onChannelMessage(BuildContext context, JavascriptMessage message)
    {
        if (message.message == 'Close') {
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: "Accueil")));
        }
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