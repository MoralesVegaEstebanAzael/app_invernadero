import 'dart:async';

import 'package:app_invernadero/src/models/producto_model.dart';
import 'package:app_invernadero/src/providers/db_provider.dart';
import 'package:app_invernadero/src/providers/producto_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

enum NavBarItem{PEDIDOS,NOTIFICACIONES,HOME,FAVORITOS,PROFILE}

class BottomNavBloc{

  static final BottomNavBloc _singleton = BottomNavBloc._internal();

  factory BottomNavBloc() {
    return _singleton;
  }

  BottomNavBloc._internal();

  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.HOME;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.PEDIDOS);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.NOTIFICACIONES);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 3:
        _navBarController.sink.add(NavBarItem.FAVORITOS);
        break;
      case 4:
        _navBarController.sink.add(NavBarItem.PROFILE);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}