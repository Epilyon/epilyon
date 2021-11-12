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
import 'package:cached_network_image/cached_network_image.dart';

import 'package:epilyon/auth.dart';
import 'package:epilyon/firebase.dart';
import 'package:epilyon/pages.dart';
import 'package:epilyon/pages/base.dart';
import 'package:epilyon/pages/login.dart';
import 'package:epilyon/widgets/dialogs.dart';

void pushMain(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MainPage()));
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // TODO: Page switching animation ?
  EpiPage? selectedPage;
  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();

    initFirebase();
    selectedPage = getUser() == null ? pages[5] : pages[0];
  }

  void showLogoutDialog() {
    showConfirmDialog(context,
        title: 'Se déconnecter',
        content: 'Voulez-vous vraiment vous déconnecter ?',
        okText: 'Oui',
        cancelText: 'Non',
        onConfirm: () => doLogout());
  }

  void doLogout() {
    showLoadingDialog(context,
        title: 'Déconnexion',
        content: 'Déconnexion en cours...',
        onContextUpdate: (ctx) => _dialogContext = ctx);

    logout().catchError((e, trace) {
      print('Error while doing logout : ' + e.toString());
      print(trace);

      showErrorDialog(context,
          title: 'Erreur',
          content: "Erreur lors de la déconnexion : " + e.toString());
    }).whenComplete(() {
      if (_dialogContext != null) {
        Navigator.pop(_dialogContext!);
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    Widget? content = selectedPage!.tabs.length > 0
        ? selectedPage!.tabs[selectedPage!.tabIndex].page
        : selectedPage!.page;

    return WillPopScope(
      onWillPop: () async => false,
      child: BasePage(
        title: selectedPage!.tabs.length > 0
            ? selectedPage!.tabs[selectedPage!.tabIndex].title
            : selectedPage!.title,
        drawer: buildDrawer(context),
        bottomNav: selectedPage!.tabs.length > 0
            ? BottomNavigationBar(
                currentIndex: selectedPage!.tabIndex,
                elevation: 20.0,
                onTap: (tab) => setState(() {
                  if (selectedPage!.tabs[tab].page != null) {
                    selectedPage!.tabIndex = tab;
                  }
                }),
                items: selectedPage!.tabs.map((page) {
                  bool selected = content == page.page;

                  return BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        page.icon,
                        width: 24,
                        color: selected ? primary : Color(0xFF999999),
                      ), // TODO: Better way (color) ?
                      title: Text(
                          page.tabTitle != null ? page.tabTitle! : page.title));
                }).toList(),
              )
            : null,
        child: content,
      ),
    );
  }

  void rebuild() {
    late ElementVisitor visitor;
    visitor = (child) {
      if (child.widget is MainPage) {
        child.markNeedsBuild();
      } else {
        for (var page in pages) {
          if (page.page == child.widget) {
            child.markNeedsBuild();
          }
        }
      }

      child.visitChildElements(visitor);
    };

    setState(() {});
    context.visitChildElements(visitor);
  }

  Widget buildDrawer(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    MediaQueryData media = MediaQuery.of(context);

    User user = getUser()!;
    String promoName = getPromoName();

    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: primary,
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  color: Colors.white,
                  fontFamily: 'LatoE',
                  fontSize: 18,
                  fontWeight: FontWeight.w600))),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme(
                      bodyText2: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18))),
              child: Container(
                padding:
                    EdgeInsets.only(left: 12.5, top: 12.5 + media.padding.top),
                height: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CachedNetworkImage(
                            imageUrl: user.avatar,
                            imageBuilder: (context, imageProvider) => Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/default_thumb.jpg"),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter)))),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left:
                                        0.75), // To compensate the use of italic
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      user.firstName,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3.0))),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 6.0,
                                                  top: 3.5),
                                              child: Text(promoName,
                                                  style: TextStyle(
                                                      height: 1,
                                                      fontFamily: 'LatoE',
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                user.lastName,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Lato2',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Lyon - ${user.promo}', // Temporary, groups will be there then
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    color: Color.fromRGBO(28, 28, 28, 0.55),
                  )
                ]),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                child: Wrap(
                    runSpacing: 10.0,
                    children: pages
                        .where((page) => page.onlyIf == null || page.onlyIf!())
                        .map((page) {
                          bool selected = page == selectedPage;
                          BorderRadius borderRadius = BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5));

                          return Container(
                            decoration: BoxDecoration(
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                            offset: Offset(-1, 0),
                                            blurRadius: 5.0,
                                            color: Color.fromRGBO(
                                                62, 62, 62, 0.45))
                                      ]
                                    : []),
                            child: Material(
                              color: selected ? Colors.white : null,
                              borderRadius: borderRadius,
                              child: InkWell(
                                borderRadius: borderRadius,
                                onTap: () {
                                  if (page.action != null) {
                                    if (page.action == 'logout') {
                                      showLogoutDialog();
                                    }
                                  } else if (page.page != null ||
                                      page.tabs.length > 0) {
                                    setState(() {
                                      selectedPage = page;
                                    });

                                    Navigator.pop(context);
                                  }
                                },
                                child: Ink(
                                  height: 55.0,
                                  child: ListTile(
                                    leading: SvgPicture.asset(page.icon,
                                        width: 24,
                                        color:
                                            selected ? primary : Colors.white),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 1.0),
                                      child: Text(page.title,
                                          style: TextStyle(
                                              color: selected
                                                  ? primary
                                                  : Colors.white)),
                                    ),
                                    trailing: SvgPicture.asset(
                                        'assets/icons/navigate_next.svg',
                                        width: 30,
                                        color:
                                            selected ? primary : Colors.white),
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .where((p) => p != null)
                        .toList()),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void rebuildAll(BuildContext context) {
  context.findAncestorStateOfType<_MainPageState>()!.rebuild();
}
