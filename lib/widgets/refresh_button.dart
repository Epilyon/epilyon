/*
 * Epilyon, keeping EPITA students organized
 * Copyright (C) 2019-2020 Adrien 'Litarvan' Navratil
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import 'dart:math';

import 'package:epilyon/widgets/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:epilyon/data.dart';
import 'package:epilyon/widgets/dialogs.dart';

// Thanks to David Anaya (https://www.davidanaya.io/) for this one

class RefreshButton extends StatefulWidget
{
  RefreshButton();

  @override
  _RefreshButtonState createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> with SingleTickerProviderStateMixin
{
  AnimationController _animationController;
  Animation<double> _animation;

  var _refreshing = false;

  @override
  void initState()
  {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease)
    );
  }

  void doRefresh(BuildContext context)
  {
    if (_refreshing) {
      return;
    }

    setState(() {
      _refreshing = true;

      _animationController.reset();
      _animationController.forward();
    });

    var snack = Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Rafraîchissement des données...'))
    );

    forceRefresh().catchError((err) {
      showErrorDialog(
          context,
          title: 'Erreur',
          content: 'Erreur lors du rafraîchissement : ' + err.toString()
      );
    }).then((_) => fetchData()).then((_) {
      AppBuilder.of(context).rebuild();
    }).whenComplete(() {
      snack.close();

      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Terminé !'), duration: Duration(seconds: 2),)
      );

      setState(() {
        _refreshing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return IconButton(
      icon: AnimatedBuilder(
          animation: _animation,
          child: Container(
              child: SvgPicture.asset(
                'assets/icons/refresh.svg',
                color: Colors.white,
              )
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value,
              child: child,
            );
          }
      ),
      onPressed: () {
        doRefresh(context);
      },
    );
  }
}
