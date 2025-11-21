import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/tasksBuilder.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import '../../shared/cubit/AppState.dart';

class NewTasksScreen extends StatelessWidget{
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, AppState>(
        listener:(context, AppState state){},
        builder: (context, AppState state){
            final cubit = TaskCubit.get(context);
            return tasksBuilder(cubit.newTasks);
        }
    );
  }
}