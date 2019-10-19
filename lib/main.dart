import 'package:flutter/material.dart';
import 'package:epilyon/pages/login.dart';

void main() => runApp(EpilyonApp());

class EpilyonApp extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: 'Epilyon',
            theme: ThemeData(
                primarySwatch: Colors.cyan,
            ),
            home: LoginPage(title: 'Epilyon'), // TODO: Handle login and refresh
        );
    }
}
