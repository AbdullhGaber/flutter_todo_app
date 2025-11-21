import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/Task.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget taskItem(BuildContext context, Map task) {
  final cubit = TaskCubit.get(context);
  return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Text(task['date']),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                Text(
                  task['time'],
                  style: TextStyle(
                      color: CupertinoColors.placeholderText,
                      fontSize: 14
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          IconButton(
              onPressed: (){
                cubit.updateTask(task['id'], 'done');
              },
              icon: Icon(
                  Icons.check_box,
                  color: Colors.green
              )
          ),
          IconButton(
              onPressed: (){
                cubit.updateTask(task['id'], 'archived');
              },
              icon: Icon(Icons.archive)
          ),
        ],
      ),
    );
}