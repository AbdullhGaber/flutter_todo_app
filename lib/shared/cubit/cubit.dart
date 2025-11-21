import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/AppState.dart';
import '../../models/Task.dart';
import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class TaskCubit extends Cubit<AppState>{
  TaskCubit() : super(InitializeAppState()){createDatabase();}

  static TaskCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarIdx());
  }

  bool isBottomSheetShown = false;

  showBottomSheetShown(){
     isBottomSheetShown = true;
     emit(ShowBottomSheetVisibility());
  }

  hideBottomSheetShown(){
    isBottomSheetShown = false;
    emit(HideBottomSheetVisibility());
  }

  late Database mDb;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() async{
    emit(TasksLoadingState());
    mDb = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,ver) {
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((_) => emit(DatabaseCreateState()));
      },
      onOpen: (database){
        getTasks(database);
      }
    );
  }

  void insertTask(Task task) async{
    emit(TasksLoadingState());
    mDb.transaction(
        (trans) {
              return trans.rawInsert('INSERT INTO tasks (title, date, time, status) VALUES ("${task.title}", "${task.time}", "${task.date}", "${task.status}")')
                  .then((value){
                emit(InsertTaskState());
                getTasks(mDb);
              });
        }
    );
  }

  updateTask(
      int taskId,
      String status
  ) async{
    emit(TasksLoadingState());
    await mDb.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = $taskId', [status]).then(
        (_){
          emit(UpdateTaskState());
          getTasks(mDb);
        }
    );
  }

  getTasks(Database database) async{
    emit(TasksLoadingState());
      newTasks.clear();
      doneTasks.clear();
      archivedTasks.clear();
      database.rawQuery('SELECT * FROM tasks').then((tasks){
       for (var task in tasks) {
         if(task['status'].toString().toLowerCase() == "new"){
           newTasks.add(task);
         }else if (task['status'].toString().toLowerCase() == "done"){
           doneTasks.add(task);
         }else if(task['status'].toString().toLowerCase() == "archived"){
           archivedTasks.add(task);
         }
       }
       emit(GetTasksState());
       print(tasks);
     });
  }
}