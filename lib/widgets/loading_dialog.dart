import 'package:flutter/material.dart';

// TODO: Simpler way ?

class LoadingDialog extends SimpleDialog
{
    LoadingDialog({
        Widget title,
        Widget content
    }) : super(
        title: title,
        children: <Widget>[
            Padding(
                // TODO: TEXT WRAPPING!
                padding: const EdgeInsets.only(left: 32.5, right: 30, top: 12.5, bottom: 8.5),
                child: Row(
                    children: <Widget>[
                        CircularProgressIndicator(
                            value: null,
                        ),
                        Flexible(child: Padding(
                            padding: const EdgeInsets.only(left: 27.5),
                            child: content,
                        ))
                    ],
                ),
            )
        ]
    );
}