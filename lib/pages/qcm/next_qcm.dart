import 'package:flutter/material.dart';

import 'package:epilyon/pages/qcm/qcm_navbar.dart';
import 'package:epilyon/widgets/layout/drawer.dart';

class NextQCMPage extends StatefulWidget
{
    NextQCMPage({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _NextQCMPageState createState() => _NextQCMPageState();
}

class _NextQCMPageState extends State<NextQCMPage>
{
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
                        Text("WIP")
                    ],
                ),
            ),
            drawer: EpilyonDrawer(),
            bottomNavigationBar: QCMNavbar(),
        );
    }
}