import 'package:epilyon/pages/home.dart';
import 'package:epilyon/state.dart';
import 'package:flutter/material.dart';

import 'package:epilyon/widgets/loading_dialog.dart';
import 'package:epilyon/auth.dart';
import 'package:epilyon/pages/ms_login.dart';
import 'package:epilyon/widgets/microsoft_button.dart';

class LoginPage extends StatefulWidget
{
    // TODO: Instead of passing title in constructor, hard code it
    LoginPage({ Key key, @required this.title }) : super(key: key);

    final String title;

    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    BuildContext _dialogContext;
    bool _refreshing;

    @override
    void initState()
    {
        super.initState();

        _refreshing = true;

        refresh().then((success) {
            if (success) {
                fetchState().then((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: "Accueil"))); // TODO: Generify?
                }); // TODO: Handle error
            } else {
                print("Refresh failed");

                setState(() {
                    _refreshing = false;
                });
            }
        }).catchError((e) {
            print("Error while doing refresh");
            print(e);

            setState(() {
                _refreshing = false;
            });
        });
    }

    void _onConnectPress(BuildContext context)
    {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                _dialogContext = context;

                return LoadingDialog(
                    title: Text("Chargement"),
                    content: Text("Création de la session..."),
                );
            }
        ).whenComplete(() {
            _dialogContext = null;
        });

        createSession().then((_) {
            if (_dialogContext == null) {
                return;
            }

            Navigator.pop(_dialogContext);
            Navigator.push(context, MaterialPageRoute(builder: (context) => MSLoginPage(title: "Connexion")));
        }).catchError((e) {
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
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text("Bienvenue", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),),
                        _refreshing ? Text("Chargement...", style: TextStyle(fontStyle: FontStyle.italic)) : Padding(
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