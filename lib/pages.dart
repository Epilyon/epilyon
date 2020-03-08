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

import 'package:epilyon/delegates.dart';
import 'package:epilyon/pages/about.dart';
import 'package:epilyon/pages/mimos.dart';
import 'package:epilyon/pages/manage/manage.dart';
import 'package:epilyon/pages/qcm/qcm_history.dart';
import 'package:epilyon/pages/qcm/qcm_result.dart';

final List<Page> pages = [
  Page(
      title: 'Q.C.M.s',
      icon: 'assets/icons/check_box.svg',
      tabIndex: 1, // TODO: Change this depending on the day/time
      tabs: [
        Page(
          title: 'Prochain Q.C.M.',
          tabTitle: 'Prochain',
          icon: 'assets/icons/edit.svg',
        ),
        Page(
            title: 'Résultats du Q.C.M.',
            tabTitle: 'Résultats',
            icon: 'assets/icons/done_all.svg',
            page: QCMResultPage()
        ),
        Page(
            title: 'Historique des Q.C.M.s',
            icon: 'assets/icons/list.svg',
            tabTitle: 'Historique',
            page: QCMHistoryPage()
        )
      ]
  ),
  Page(
    title: 'MiMos',
    icon: 'assets/icons/work.svg',
    page: MimosPage()
  ),
  Page(
    title: 'Gérer',
    icon: 'assets/icons/build.svg',
    onlyIf: () => isUserAdmin() || isUserDelegate() || false,
    tabIndex: 0,
    tabs: [
      Page(
        title: 'Gestion générale',
        tabTitle: 'Général',
        icon: 'assets/icons/build.svg',
        page: ManagePage()
      ),
      Page(
        title: 'Gestion des MiMos',
        tabTitle: 'MiMos',
        icon: 'assets/icons/work.svg',
        page: MimosPage(canAdd: true, canRemove: true)
      ),
      Page(
        title: 'Gestion des Q.C.M.s',
        tabTitle: 'Q.C.M.s',
        icon: 'assets/icons/check_box.svg'
      )
    ]
  ),
  Page(
    title: 'Paramètres',
    icon: 'assets/icons/settings.svg',
    //page:
  ),
  Page(
      title: 'Se déconnecter',
      icon: 'assets/icons/first_page.svg',
      action: 'logout'
  ),
  Page(
      title: 'À Propos',
      icon: 'assets/icons/info.svg',
      page: AboutPage()
  ),
];

class Page
{
  String title;
  String tabTitle;
  String icon;
  Widget page;
  List<Page> tabs;
  String action;
  int tabIndex;

  bool Function() onlyIf;

  Page({
    @required this.title,
    this.tabTitle,
    @required this.icon,
    this.page,
    this.tabs = const [],
    this.action,
    this.tabIndex = 0,

    this.onlyIf
  });
}