import 'package:epilyon/pages/ms_login.dart';
import 'package:epilyon/widgets/microsoft_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget
{
    LoginPage({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    void _onConnectPress(BuildContext context)
    {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MSLoginPage(title: "Connexion")));
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: MicrosoftButton(
                              text: "Se connecter avec Microsoft", // TODO: Lang
                              onPressed: () => _onConnectPress(context),
                          ),
                        )
                    ],
                ),
            ),
        );
    }
}