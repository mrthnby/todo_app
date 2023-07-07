import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/local_storage.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocalStorage localStorage;
  late List<Task> alltasks;
  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    alltasks = <Task>[];
    _getTasksFromStorage();
  }

  _getTasksFromStorage() async {
    alltasks = await localStorage.getAllTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(
              "To-Do",
              style: GoogleFonts.kanit(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: alltasks.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: alltasks.length,
                        itemBuilder: (context, index) {
                          var currentTask = alltasks[index];
                          return Dismissible(
                            onDismissed: (direction) {
                              alltasks.remove(currentTask);
                              localStorage.deleteTask(task: currentTask);
                              setState(() {});
                            },
                            key: Key(currentTask.id),
                            child: TaskCard(task: currentTask),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "lets add some tasks to do :)",
                          style: GoogleFonts.kanit(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "bottomnewtask",
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        _showAddTaskField(context);
                      },
                      child: Text(
                        "Write a new task",
                        style: GoogleFonts.kanit(
                          color: Colors.grey.shade500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showSearchScreen();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(50, 50),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskField(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            color: const Color.fromRGBO(109, 109, 109, 1),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 5,
            ),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: Hero(
                tag: "bottomnewtask",
                child: TextField(
                  onSubmitted: (value) async {
                    Navigator.of(context).pop();
                    var time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    var newTask = Task.create(
                      value,
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        time!.hour,
                        time.minute,
                      ),
                    );
                    alltasks.add(newTask);
                    await localStorage.addTask(task: newTask);
                    setState(() {});
                  },
                  style: GoogleFonts.kanit(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.grey,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    hintText: "Write a new task",
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showSearchScreen() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(
        tasks: alltasks,
      ),
    );
    _getTasksFromStorage();
  }
}
