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
import 'dart:convert';

dynamic parseResponse(String body)
{
  var json;

  try {
    json = jsonDecode(body);

    if (json['success'] == null) {
      throw 'No success field';
    }
  } catch (e, trace) {
    print('JSON decoding error : ' + e.toString());
    print(trace);

    throw UnreachableAPIException();
  }

  if (json['success'] != true) {
    throw json['error'];
  }

  return json;
}

class UnreachableAPIException implements Exception
{
  @override
  String toString()
  {
    return 'Serveur inaccessible';
  }
}