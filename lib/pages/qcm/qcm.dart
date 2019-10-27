import 'package:epilyon/pages/qcm/last_qcm.dart';
import 'package:epilyon/pages/qcm/next_qcm.dart';
import 'package:flutter/material.dart';
import 'package:epilyon/widgets/layout/drawer.dart';

class QCMPage extends StatefulWidget
{
    QCMPage({ Key key }) : super(key: key);

    @override
    _QCMPageState createState() => _QCMPageState();
}

class _QCMPageState extends State<QCMPage>
{
    int _tabIndex;

    final List<String> _titles = [
        "Prochain QCM",
        "Dernier QCM"
    ];
    final List<Widget> _tabs = [
        NextQCMTab(),
        LastQCMTab()
    ];

    @override
    void initState()
    {
        super.initState();

        var h =  DateTime.now().hour;
        _tabIndex = h >= 6 && h <= 12 ? 0 : 1;
    }

    void _onTabTap(int tab)
    {
        setState(() {
            _tabIndex = tab;
        });
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text(_titles[_tabIndex]),
            ),
            body: _tabs[_tabIndex],
            drawer: EpilyonDrawer(),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _tabIndex,
                onTap: _onTabTap,
                items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit),
                        title: Text("Prochain")
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        title: Text("Résultats"),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        title: Text("Précédents")
                    )
                ],
            )
        );
    }
}