import 'package:flutter/material.dart';
import 'package:epilyon/auth.dart';

class HomePage extends StatefulWidget
{
    HomePage({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
    var _logged = false;

    @override
    void initState()
    {
        super.initState();
        login().then((_) => setState(() => _logged = true));
    }

    @override
    Widget build(BuildContext context)
    {
        var user = getUser();

        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text(_logged ? "Bienvenue " + user.name + " (" + user.region + " " + user.promo + ")" : "Chargement...")
                    ],
                ),
            ),
        );
    }
}