import 'package:flutter/material.dart';
import 'package:local_db_app/models/task_model.dart';
import 'package:local_db_app/viewmodels/db_viewmodels.dart';
import 'package:local_db_app/viewmodels/theme_viewmodel.dart';
import 'package:local_db_app/views/progress_screen.dart';
import 'package:local_db_app/views/widgets/task_card.dart';
import 'package:local_db_app/views/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  HomeScreen({super.key});

  /// Show dialog to add or edit a task
  void _showTaskDialog(BuildContext context, [Task? task]) {
    if (task != null) {
      titleController.text = task.title;
      descriptionController.text = task.description;
    } else {
      titleController.clear();
      descriptionController.clear();
    }
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task == null ? 'Add Task' : 'Edit Task',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 20),

                  /// Title Field
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  /// Description Field
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  SizedBox(height: 24),

                  /// Submit Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        final newTask = Task(
                          id: task?.id,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                        );
                        final taskViewModel = context.read<TaskViewModel>();
                        task == null
                            ? taskViewModel.addTask(newTask)
                            : taskViewModel.updateTask(newTask);

                        Navigator.pop(context);
                      },
                      child: Text(task == null ? 'Add Task' : 'Update Task'),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    final themeVM = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(taskVM.isGridView ? Icons.view_list : Icons.grid_view),
          tooltip: 'Toggle View',
          onPressed: () {
            taskVM.toggleViewMode();
          },
        ),
        title: Text('📝 ToDo Tasks'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeVM.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeVM.toggleTheme();
            },
          ),
        ],
      ),
      body:
          taskVM.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 🔍 Search Field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => taskVM.setSearchQuery(value),
                    ),
                    SizedBox(height: 12),

                    // 🔽 Filter Dropdown
                    // Row(
                    //   children: [
                    //     Text("Filter:"),
                    //     SizedBox(width: 10),
                    //     DropdownButton<TaskStatusFilter>(
                    //       value: taskVM.filter,
                    //       onChanged: (value) {
                    //         if (value != null) taskVM.setFilter(value);
                    //       },
                    //       items: [
                    //         DropdownMenuItem(
                    //           value: TaskStatusFilter.all,
                    //           child: Text('All'),
                    //         ),
                    //         DropdownMenuItem(
                    //           value: TaskStatusFilter.completed,
                    //           child: Text('Completed'),
                    //         ),
                    //         DropdownMenuItem(
                    //           value: TaskStatusFilter.notCompleted,
                    //           child: Text('Pending'),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surface, // Dynamic background
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black26
                                    : Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filter:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurface, // Dynamic text color
                            ),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<TaskStatusFilter>(
                            value: taskVM.filter,
                            underline: SizedBox(), // Remove default underline
                            borderRadius: BorderRadius.circular(10),
                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurface, // Dynamic text
                            ),
                            dropdownColor:
                                Theme.of(
                                  context,
                                ).colorScheme.surface, // Dropdown background
                            onChanged: (value) {
                              if (value != null) taskVM.setFilter(value);
                            },
                            items: [
                              DropdownMenuItem(
                                value: TaskStatusFilter.all,
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: TaskStatusFilter.completed,
                                child: Text('Completed'),
                              ),
                              DropdownMenuItem(
                                value: TaskStatusFilter.notCompleted,
                                child: Text('Pending'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // 📋 Task List
                    Expanded(
                      child:
                          taskVM.filteredTasks.isEmpty
                              ? Center(child: Text('No tasks found!'))
                              : taskVM.isGridView
                              ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      // childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                itemCount: taskVM.filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final todo = taskVM.filteredTasks[index];
                                  // return _buildTaskCard(context, todo, taskVM);
                                  return TaskCard(
                                    task: todo,
                                    onEdit:
                                        () => _showTaskDialog(context, todo),
                                    onDelete: () => taskVM.deleteTask(todo.id!),
                                  );
                                },
                              )
                              : ListView.separated(
                                itemCount: taskVM.filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final todo = taskVM.filteredTasks[index];
                                  // return _buildTaskTile(context, todo, taskVM);
                                  return TaskTile(
                                    task: todo,
                                    onEdit:
                                        () => _showTaskDialog(context, todo),
                                    onDelete: () => taskVM.deleteTask(todo.id!),
                                  );
                                },
                                separatorBuilder: (_, __) => Divider(),
                              ),
                    ),
                  ],
                ),
              ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => _showTaskDialog(context),
      //   label: Text('New Task'),
      //   icon: Icon(Icons.add),
      // ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // heroTag: 'Progress',
            child: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProgressScreen()),
              );
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () => _showTaskDialog(context),
            label: Text('New Task'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
