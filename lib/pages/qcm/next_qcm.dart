import 'package:flutter/material.dart';

class NextQCMTab extends StatefulWidget
{
    NextQCMTab({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _NextQCMTabState createState() => _NextQCMTabState();
}

class _NextQCMTabState extends State<NextQCMTab>
{
    @override
    Widget build(BuildContext context)
    {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text("WIP")
                ],
            ),
        );
    }
}