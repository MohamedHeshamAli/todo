import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo/modules/ArchivedTasks/Archived_tasks_screen.dart';
import 'package:todo/modules/DoneTasks/Done_tasks_screen.dart';
import 'package:todo/modules/newTasks/new_tasks_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constans.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  @override
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleControllar = TextEditingController();
  TextEditingController timeControllar = TextEditingController();
  TextEditingController dateControllar = TextEditingController();

  // void initState() {
  //   super.initState();
  //   CreateDataBase();
  // }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext ctx) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext ctx, AppStates state) {
          if (state is AppInsertDataBase) Navigator.pop(context);
        },
        builder: (BuildContext ctx, AppStates state) {
          AppCubit cuibit = AppCubit.get(ctx);
          return Scaffold(
            key: ScaffoldKey,
            body: false
                ? Center(child: CircularProgressIndicator())
                : cuibit.Screen[cuibit.currentIndx],
            appBar: AppBar(
              title: Text(cuibit.titles[cuibit.currentIndx]),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cuibit.showBottomSheet ? Icons.add : Icons.edit),
              onPressed: () {
                if (cuibit.showBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cuibit.insertDataBase(
                        title: titleControllar.text,
                        time: timeControllar.text,
                        date: dateControllar.text);
                    // insertDataBase(
                    //         title: titleControllar.text,
                    //         time: timeControllar.text,
                    //         date: dateControllar.text)
                    //     .then((value) {
                    //
                    //
                    //
                    //   // setState(() {
                    //   //   getDataFromDataBase(database).then((value) => tasks = value);
                    //   //   showBottomSheet = false;
                    //   // });
                    // });
                  }
                } else {
                  ScaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextField(
                                          prefix: Icons.title,
                                          controller: titleControllar,
                                          radius: 15,
                                          lable: "Task Title",
                                          validator: (val) {
                                            print(val);
                                            if (val!.isEmpty)
                                              return "title must not be empty";
                                            else
                                              return null;
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      defaultTextField(
                                          prefix: Icons.watch_later_rounded,
                                          controller: timeControllar,
                                          radius: 15,
                                          lable: "Time",
                                          readOnly: true,
                                          onTab: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) => value != null
                                                ? timeControllar.text =
                                                    value.format(context)
                                                : null);
                                          },
                                          validator: (val) {
                                            print(val);
                                            if (val!.isEmpty)
                                              return "Time must not be empty";
                                            else
                                              return null;
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      defaultTextField(
                                          prefix: Icons.calendar_today,
                                          controller: dateControllar,
                                          radius: 15,
                                          lable: "Date",
                                          readOnly: true,
                                          onTab: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.now()
                                                        .add(Duration(
                                                            days: 150)))
                                                .then((value) => value != null
                                                    ? dateControllar.text =
                                                        DateFormat.yMMMd()
                                                            .format(value)
                                                    : null);
                                          },
                                          validator: (val) {
                                            print(val);
                                            if (val!.isEmpty)
                                              return "Time must not be empty";
                                            else
                                              return null;
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )))
                      .closed
                      .then((value) {
                    cuibit.changeBottomSheetState(false);
                  });
                  cuibit.changeBottomSheetState(true);
                }

                //print(await databse.rawQuery('SELECT * FROM tasks'));
                // await databse.execute('DELETE FROM  tasks');
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cuibit.currentIndx,
              onTap: (val) {
                cuibit.changeIndex(val);
              },
              type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'tasks',
                    backgroundColor: Colors.blueAccent),
                BottomNavigationBarItem(
                    backgroundColor: Colors.blue,
                    icon: Icon(
                      Icons.done,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                    backgroundColor: Colors.blue,
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
