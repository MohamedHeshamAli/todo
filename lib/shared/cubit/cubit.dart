import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/ArchivedTasks/Archived_tasks_screen.dart';
import 'package:todo/modules/DoneTasks/Done_tasks_screen.dart';
import 'package:todo/modules/newTasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(BuildContext ctx) => BlocProvider.of(ctx);
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  int currentIndx = 0;
  List Screen = [NewTasksScreen(), DoneTasksScreen(), ArchivedTasksScreen()];
  List titles = ["New Tasks", 'DoneTasks', 'ArchivedTasks'];
  late Database database;
  bool showBottomSheet = false;
  void createDataBase() async {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      db
          .execute('create table tasks(id integer primary key , '
              'title text , date text , time text , status text)')
          .then((value) {
        print(''
            'database created');
      }).catchError((onError) {
        print('creating error $onError');
      });
    }, onOpen: (db) {
      print('database opened');
      getDataFromDataBase(db);
    }).then((value) {
      database = value;
      emit(AppCreatDataBase());
    });
  }

  void insertDataBase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database
        .transaction((txn) => txn.execute('insert into tasks ('
            'title  ,  time  , date  , status ) values("$title" , "$time","$date","new")'))
        .then((value) {
      print('insert successfully ');

      //another solution

      emit(AppInsertDataBase());
      getDataFromDataBase(database);
    }).catchError((onError) {
      print('insert error $onError');
    });
  }

  void getDataFromDataBase(Database database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('select * from tasks').then((value) {
      value.forEach((element) {
        if (element["status"] == "new")
          newTasks.add(element);
        else if (element["status"] == "done")
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(AppGetDataBase());
    });
  }

  void updateDataBase({
    @required status,
    @required id,
  }) async {
    database.rawUpdate('update tasks set status= ? where id= ? ',
        ["$status", id]).then((value) {
      emit(AppUpdateDataBase());
      getDataFromDataBase(database);
    });
  }

  void deleteDataBase({
    @required id,
  }) async {
    database.rawDelete('delete from tasks  where id= ${id} ').then((value) {
      emit(AppDeleteDataBase());
      getDataFromDataBase(database);
    });
  }

  void changeIndex(int val) {
    currentIndx = val;
    emit(AppChangeBottomNavState());
  }

  void changeBottomSheetState(bool isShow) {
    showBottomSheet = isShow;
    emit(AppChangeBottomsheetState());
  }
}
