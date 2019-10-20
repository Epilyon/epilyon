import 'package:flutter/material.dart';

class LoadingDialog extends SimpleDialog
{
    LoadingDialog({
        Widget title,
        Widget content
    }) : super(
        title: title,
        children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 32.5, right: 20, top: 12.5, bottom: 8.5),
                child: Row(
                    children: <Widget>[
                        CircularProgressIndicator(
                            value: null,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 27.5),
                            child: content,
                        ) // TODO: Lang
                    ],
                ),
            )
        ]
    );
}