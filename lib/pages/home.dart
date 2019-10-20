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
    @override
    void initState()
    {
        super.initState();
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
                        Text("Bienvenue " + user.name + " (" + user.region + " " + user.promo + ")")
                    ],
                ),
            ),
        );
    }
}