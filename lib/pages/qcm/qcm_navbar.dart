import 'package:flutter/material.dart';

class QCMNavbar extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit),
                    title: Text("Prochain")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    title: Text("Résultats")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    title: Text("Précédents")
                )
            ],
        );
    }
}