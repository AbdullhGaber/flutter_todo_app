import 'package:flutter/material.dart';
import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:todo_app/shared/components/task_item.dart';

Widget tasksBuilder(List<Map> tasks) => Conditional.single(
  condition: tasks.isNotEmpty,
  widget: ListView.separated(
      itemBuilder: (context, idx) => taskItem(context, tasks[idx]),
      separatorBuilder: (context, idx) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 20),
        child: Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length
  ),
  fallback: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);

