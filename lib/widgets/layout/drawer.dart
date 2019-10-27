import 'package:epilyon/auth.dart';
import 'package:epilyon/pages/login.dart';
import 'package:epilyon/pages/qcm/qcm.dart';
import 'package:flutter/material.dart';

class EpilyonDrawer extends StatelessWidget
{
    // TODO: Instead use body variable changing

    @override
    Widget build(BuildContext context)
    {
        return Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                    DrawerHeader(
                        child: Text("Epilyon ??"),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor
                        ),
                    ),
                    ListTile(
                        leading: Icon(Icons.school),
                        title: Text("Q.C.M."),
                        onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QCMPage()));
                        },
                    ),
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text("Se déconnecter"),
                        onTap: () {
                            logout().then((success) {
                                // TODO: Loading
                                if (success) {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: "Epilyon")));
                                }
                            });
                        }
                    )
                ])
        );
    }
}