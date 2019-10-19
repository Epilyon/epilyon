import 'package:flutter/material.dart';

class MicrosoftButton extends StatelessWidget
{
    final GestureTapCallback onPressed;
    final String text;

    MicrosoftButton({ @required this.onPressed, @required this.text });

    @override
    Widget build(BuildContext context)
    {
        return Material(
            elevation: 15.0,
            color: Colors.black,
            child: InkWell(
                onTap: onPressed,
                child: Ink(
                    height: 45.0,
                    child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Image(
                                      image: AssetImage("assets/ms_icon.png"),
                                      height: 21.0,
                                      width: 21.0,
                                  ),
                                ),
                                Text(
                                    text,
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.0),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}