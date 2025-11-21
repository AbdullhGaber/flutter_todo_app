import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/task_text_field.dart';
import 'package:todo_app/shared/cubit/AppState.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import '../models/Task.dart';


class HomeLayout extends StatelessWidget{

  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  PersistentBottomSheetController? sheetController;

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return TaskCubit();
      },
      child: BlocConsumer<TaskCubit,AppState>(
          listener: (context, AppState state){
              if(state is InsertTaskState){
                sheetController?.close();
              }
          },
          builder: (BuildContext context, AppState state) {
             final cubit = TaskCubit.get(context);
             return  Scaffold(
               key: scaffoldKey,
               appBar: AppBar(
                   backgroundColor: Colors.blue,
                   foregroundColor: Colors.white,
                   title: Text("Todo App",style: TextStyle(fontWeight: FontWeight.bold))
               ),
               floatingActionButton: (cubit.currentIndex == 0)? Builder(
                   builder: (innerContext) {
                     return FloatingActionButton(
                       onPressed: () async {
                         if(!cubit.isBottomSheetShown){
                           sheetController = showBottomSheet(
                             context: innerContext,
                             enableDrag: true,
                             elevation: 15,
                             builder: (_) => Container(
                               padding: EdgeInsets.all(20),
                               width: double.infinity,
                               color: Colors.white,
                               child: Form(
                                   key: formKey,
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       taskTextField(
                                           controller: titleController,
                                           keyboardType: TextInputType.text,
                                           validator: (text){
                                             if(titleController.text.isEmpty){
                                               return "Field Must Be Initialized";
                                             }
                                             return null;
                                           },
                                           prefixIcon: Icon(Icons.title),
                                           label: "Task Title"
                                       ),
                                       SizedBox(height: 15),
                                       taskTextField(
                                           controller: timeController,
                                           validator: (value) {
                                             if (value!.isEmpty) {
                                               return 'time must not be empty';
                                             }
                                             return null;
                                           },
                                           keyboardType: TextInputType.datetime,
                                           onTap: (){
                                             showTimePicker(context: context, initialTime: TimeOfDay.now())
                                                 .then(
                                                     (value){
                                                   if(innerContext.mounted){
                                                     timeController.text = value!.format(innerContext).toString();
                                                   }
                                                 }
                                             );
                                           },
                                           label: "Task Time",
                                           prefixIcon: Icon(Icons.watch_later_outlined)
                                       ),
                                       SizedBox(height: 15),
                                       taskTextField(
                                           controller: dateController,
                                           validator: (value) {
                                             if (value!.isEmpty) {
                                               return 'date must not be empty';
                                             }
                                             return null;
                                           },
                                           keyboardType: TextInputType.datetime,
                                           onTap: (){
                                             showDatePicker(
                                                 context: context,
                                                 initialDate: DateTime.now(),
                                                 firstDate: DateTime.now(),
                                                 lastDate: DateTime.parse('2026-18-12')
                                             ).then(
                                                     (value){
                                                   dateController.text = DateFormat.yMMMd().format(value!);
                                                 }
                                             );
                                           },
                                           prefixIcon: Icon(Icons.calendar_month),
                                           label: "Task Date"
                                       ),
                                     ],
                                   )
                               ),
                             ),
                           );
                           sheetController!.closed.then( (_) => cubit.hideBottomSheetShown() );
                           cubit.showBottomSheetShown();
                         }else{
                           if (formKey.currentState!.validate()){
                             final task = Task(
                                 title: titleController.text,
                                 time: timeController.text,
                                 date: dateController.text,
                                 status: "NEW"
                             );
                             cubit.insertTask(task);
                             titleController.text = "";
                             timeController.text = "";
                             dateController.text = "";
                           }
                         }
                       },
                       shape: CircleBorder(),
                       backgroundColor: Colors.blue,
                       foregroundColor: Colors.white,
                       child: (cubit.isBottomSheetShown)? Icon(Icons.add) : Icon(Icons.edit),
                     );
                   }
               ) : null,
               body: Conditional.single(
                   condition: state is! TasksLoadingState,
                   widget: cubit.screens[cubit.currentIndex],
                   fallback: Center(child: CircularProgressIndicator())
               ),
               bottomNavigationBar: BottomNavigationBar(
                   type: BottomNavigationBarType.fixed,
                   currentIndex: cubit.currentIndex,
                   fixedColor: Colors.blue,
                   onTap: (int index){
                     cubit.changeIndex(index);
                   },
                   items : [
                     BottomNavigationBarItem(
                       label: "Tasks",
                       icon: Icon(Icons.menu),
                     ),
                     BottomNavigationBarItem(
                       label: "Done",
                       icon: Icon(Icons.check_circle_outline),
                     ),
                     BottomNavigationBarItem(
                       label: "Archived",
                       icon: Icon(Icons.archive_outlined),
                     ),
                   ]
               ),
             );
          },
      )
    );
  }
}