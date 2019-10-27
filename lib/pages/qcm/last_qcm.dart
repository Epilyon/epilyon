import 'package:flutter/material.dart';

import 'package:epilyon/state.dart';

class LastQCMTab extends StatefulWidget
{
    LastQCMTab({ Key key, this.title }) : super(key: key);

    final String title;

    @override
    _LastQCMTabState createState() => _LastQCMTabState();
}

class _LastQCMTabState extends State<LastQCMTab>
{
    double total;

    @override
    void initState()
    {
        super.initState();

        Map marks = state['last_qcm']['values'];
        total = marks.values.fold(0, (a, b) => a + b) / 70.0 * 20.0; // TODO: Do that in server-side?
    }

    @override
    Widget build(BuildContext context)
    {
        Map marks = state['last_qcm']['values'];
        var subjects = <Widget>[];

        for (var subject in marks.keys) {
            subjects.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(subject + " : ", style: TextStyle(fontSize: 16)),
                    Text(marks[subject].toStringAsFixed(1) + "/10", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
                ],
            ));
        }

        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(total.toStringAsFixed(2) + "/20", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                          children: subjects
                      ),
                    )
                ],
            ),
        );
    }
}