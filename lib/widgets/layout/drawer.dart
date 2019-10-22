import 'package:flutter/material.dart';
import 'package:epilyon/pages/qcm/next_qcm.dart';

class EpilyonDrawer extends StatelessWidget
{
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextQCMPage(title: "Prochain QCM"))); // TODO: Adapt on time
                        },
                    )
                ])
        );
    }
}