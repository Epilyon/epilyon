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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

double barHeight = 54.0;

class BasePage extends StatefulWidget
{
  final String title;
  final Widget drawer;
  final Widget bottomNav;
  final Widget child;

  BasePage({ Key key, this.title, this.drawer, this.bottomNav, this.child }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: buildAppBar(context, barHeight),
        drawer: widget.drawer,
        bottomNavigationBar: widget.bottomNav,
        body: SingleChildScrollView(
            child: widget.child
        )
    );
  }

  Widget buildAppBar(BuildContext context, double height)
  {
    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(6, 6, 6, 0.35),
            offset: Offset(0, 2.0),
            blurRadius: 5.0,
          )
        ]),
        child: AppBar(
          elevation: 0.0,
          title: Text(widget.title),
          titleSpacing: 3.0,
          leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: SvgPicture.asset(
                    widget.drawer != null
                        ? 'assets/icons/menu.svg'
                        : 'assets/icons/arrow_back.svg',
                    width: 26,
                    height: 26,
                  ),
                  onPressed: () {
                    if (widget.drawer != null) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              }
          ),
        ),
      ),
      preferredSize: Size.fromHeight(height),
    );
  }
}
