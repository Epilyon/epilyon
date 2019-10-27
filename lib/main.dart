import 'package:flutter/material.dart';
import 'package:epilyon/pages/login.dart';

// TODO: Move every http call in a separated file, manage async and errors properly

void main() => runApp(EpilyonApp());

class EpilyonApp extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: 'Epilyon',
            theme: ThemeData(
                primaryColor: Colors.lightGreenAccent[700],
            ),
            home: LoginPage(title: 'Epilyon'), // TODO: Handle login and refresh
        );
    }
}
