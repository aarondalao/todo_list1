/*
* written by: Aaron John Dave Dalao
* 20083979@tafe.wa.edu.au / aaron.dalao@gmail.com
*
* */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_list1/services/local_hive_datasource.dart';
import 'package:todo_list1/services/local_sqlite_datasource.dart';
import 'package:todo_list1/services/remote_api_datasource.dart';
import 'package:todo_list1/services/todo_datasource.dart';

import 'dart:io' show Platform;
import '../models/todo.dart';

class DataServiceManager implements TodoDatasource {
  late final TodoDatasource _local;
  final TodoDatasource _remote = RemoteApiDatasource();

  DataServiceManager() {
    if (kIsWeb) {
      _local = LocalHiveDatasource();
    } else {
      _local = LocalSQLiteDatasource();
    }
  }

  Future<bool> _checkConnectivity() async {
    // if (!Platform.isAndroid ||
    //     !Platform.isWindows ||
    //     !Platform.isFuchsia ||
    //     !Platform.isIOS ||
    //     !Platform.isLinux ||
    //     !Platform.isMacOS) {
    //   if (kIsWeb &&
    //       await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    //     return false;
    //   }
    // }
    // return true;

    if (kIsWeb ||
        await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> addTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.addTodo(t)
        : await _local.addTodo(t);
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.updateTodo(t)
        : await _local.updateTodo(t);
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    return await _checkConnectivity()
        ? await _remote.deleteTodo(t)
        : await _local.deleteTodo(t);
  }

  @override
  Future<List<Todo>> getAllTodo() async {
    return await _checkConnectivity()
        ? await _remote.getAllTodo()
        : await _local.getAllTodo();
  }

  @override
  Future<List<Map<String, Object?>>> getId(int i) async {
    return await _checkConnectivity()
        ? await _remote.getId(i)
        : await _local.getId(i);
  }
}
