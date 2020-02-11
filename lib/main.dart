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
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:epilyon/pages/refresh.dart';

const VERSION = 'v0.1.0';

void main()
{
  initializeDateFormatting('fr_FR');

  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Epilyon',
      theme: ThemeData(
        // TODO: Custom theming
        primaryColor: Color(0xFF027CFF), // 0xFF8643e6
        canvasColor: Color(0xFFF5F7F9),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: TextStyle(fontFamily: 'Lato2', fontSize: 19, fontWeight: FontWeight.w600)
          ),
          elevation: 0
        )
      ),
      home: RefreshPage(),
    );
  }
}
