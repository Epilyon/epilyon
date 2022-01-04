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
import 'package:epilyon/pages/task/task_list.dart';
import 'package:flutter/material.dart';

import 'package:epilyon/delegates.dart';
import 'package:epilyon/pages/about.dart';
import 'package:epilyon/pages/mimos.dart';
import 'package:epilyon/pages/manage/manage.dart';
import 'package:epilyon/pages/mcq/mcq_history.dart';
import 'package:epilyon/pages/mcq/mcq_result.dart';

final List<EpiPage> pages = [
  EpiPage(
      title: 'Q.C.M.s',
      icon: 'assets/icons/check_box.svg',
      tabIndex: 1, // TODO: Change this depending on the day/time
      tabs: [
        EpiPage(
          title: 'Prochain Q.C.M.',
          tabTitle: 'Prochain',
          icon: 'assets/icons/edit.svg',
        ),
        EpiPage(
            title: 'Résultats du Q.C.M.',
            tabTitle: 'Résultats',
            icon: 'assets/icons/done_all.svg',
            page: MCQResultPage()),
        EpiPage(
            title: 'Historique des Q.C.M.s',
            icon: 'assets/icons/list.svg',
            tabTitle: 'Historique',
            page: MCQHistoryPage())
      ]),
  // EpiPage(title: 'MiMos', icon: 'assets/icons/work.svg', page: MimosPage()),
  EpiPage(title: 'Tâches', icon: 'assets/icons/work.svg', page: TaskPage()),
  EpiPage(
      title: 'Gérer',
      icon: 'assets/icons/build.svg',
      onlyIf: () => isUserAdmin() || isUserClassRep() || false,
      tabIndex: 0,
      tabs: [
        EpiPage(
            title: 'Gestion générale',
            tabTitle: 'Général',
            icon: 'assets/icons/build.svg',
            page: ManagePage()),
        EpiPage(
            title: 'Gestion des MiMos',
            tabTitle: 'MiMos',
            icon: 'assets/icons/work.svg',
            page: MimosPage(canAdd: true, canRemove: true)),
        // EpiPage(
        //   title: 'Gestion des Q.C.M.s',
        //   tabTitle: 'Q.C.M.s',
        //   icon: 'assets/icons/check_box.svg'
        // )
      ]),
  EpiPage(
    title: 'Paramètres',
    icon: 'assets/icons/settings.svg',
    //page:
  ),
  EpiPage(
      title: 'Se déconnecter',
      icon: 'assets/icons/first_page.svg',
      action: 'logout'),
  EpiPage(title: 'À Propos', icon: 'assets/icons/info.svg', page: AboutPage()),
];

class EpiPage {
  String title;
  String? tabTitle;
  String icon;
  Widget? page;
  List<EpiPage> tabs;
  String? action;
  int tabIndex;

  bool Function()? onlyIf;

  EpiPage(
      {required this.title,
      this.tabTitle,
      required this.icon,
      this.page,
      this.tabs = const [],
      this.action,
      this.tabIndex = 0,
      this.onlyIf});
}
