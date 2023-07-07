import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/task_model.dart';
import '../services/local_storage.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late Color checkColor;
  late Color boxColor;
  late LocalStorage localStorage;
  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.isCompleted) {
      checkColor = Colors.green;
      boxColor = Colors.green.withOpacity(.2);
    } else {
      checkColor = Colors.grey.shade400;
      boxColor = Colors.white;
    }
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        width: MediaQuery.of(context).size.width - 50,
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              setState(() {
                widget.task.isCompleted = !widget.task.isCompleted;
                localStorage.updateTask(task: widget.task);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: checkColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {},
            child: Text(
              widget.task.name,
            ),
          ),
          subtitle: Text(DateFormat("hh:mm a").format(widget.task.date)),
        ),
      ),
    );
  }
}
