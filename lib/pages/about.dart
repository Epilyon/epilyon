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
import 'package:url_launcher/url_launcher.dart';

import 'package:epilyon/main.dart';
import 'package:epilyon/widgets/button.dart';
import 'package:epilyon/widgets/card.dart';

class AboutPage extends StatefulWidget
{
  AboutPage({ Key key }) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 45.0, bottom: 10.0),
            child: SvgPicture.asset('assets/icons/epilyon.svg', width: 50.0,),
          ),
          Text('Epilyon', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w500),),
          Text(VERSION, style: TextStyle(fontFamily: 'Lato2', fontSize: 22),),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Copyright (c) 2019-2020 Adrien 'Litarvan' Navratil", style: TextStyle(fontFamily: 'Lato', fontSize: 14),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 30.0),
            child: EpiButton(
                onPressed: () => _launchURL('https://github.com/Epilyon/epilyon/raw/master/LICENSE'),
                text: 'License',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: EpiCard(
                title: 'Remerciements',
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                  child: Text(
                    "Mathis P., Louis P. et Ugo M.\n"
                    "Valentin C.\n"
                    "Martin S.\n"
                    "Matthieu (utybo)\n"
                    "Yann Michaux\n"
                    "Théo (Thelox), Thomas (Uxon)\n"
                    "Shika",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      height: 1.5
                    ),
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }

  _launchURL(url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}