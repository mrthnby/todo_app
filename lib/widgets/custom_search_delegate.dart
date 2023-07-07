import 'package:flutter/material.dart';
import '../main.dart';
import '../models/task_model.dart';
import '../services/local_storage.dart';
import 'task_card.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> tasks;

  CustomSearchDelegate({required this.tasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isNotEmpty ? query = "" : null;
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> allTasks = tasks
        .where(
          (element) => element.name.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return allTasks.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allTasks.length,
            itemBuilder: (context, index) {
              var currentTask = allTasks[index];
              return Dismissible(
                key: Key(currentTask.id),
                onDismissed: (direction) async {
                  await  locator<LocalStorage>().deleteTask(task: currentTask);
                },
                child: TaskCard(
                  task: currentTask,
                ),
              );
            },
          )
        : const Center(
            child: Text("no result found"),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
