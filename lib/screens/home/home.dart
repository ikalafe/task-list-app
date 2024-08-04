// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/home/bloc/task_list_bloc.dart';
import 'package:task_list/widgets.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  late double _deviceHeight;
  final TextEditingController controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.primary,
        foregroundColor: themeData.colorScheme.onPrimary,
        toolbarHeight: _deviceHeight * 0.01,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                create: (context) => EditTaskCubit(
                  TaskEntity(),
                  context.read<Repository<TaskEntity>>(),
                ),
                child: EditTaskScreen(),
              ),
            ),
          );
        },
        label: const Row(
          children: [
            Text('Add New Task'),
            SizedBox(
              width: 10,
            ),
            Icon(Iconsax.add_square),
          ],
        ),
      ),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(
          context.read<Repository<TaskEntity>>(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primaryContainer
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      //Title App Bar And Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.headlineSmall!.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(
                            Iconsax.share,
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _deviceHeight * 0.015,
                      ),
                      Container(
                        height: 44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Builder(
                          builder: (context) {
                            return TextField(
                              onChanged: (value) {
                                context
                                    .read<TaskListBloc>()
                                    .add(TaskListSearch(value));
                              },
                              controller: controller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Iconsax.search_normal_1_copy,
                                  color: Color(0xffAFBED0),
                                ),
                                hintText: 'Search tasks...',
                                hintStyle: TextStyle(
                                  color: Color(0xffAFBED0),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<Repository<TaskEntity>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 32,
                              ),
                            ),
                          );
                        } else {
                          throw Exception('State Is Not Valid');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.headlineSmall!.apply(
                      fontSizeFactor: 0.9,
                      fontWeightDelta: 3,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 70,
                    height: 3,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
                },
                textColor: secondyTextColor,
                color: const Color(0xffEAEFF5),
                elevation: 0.5,
                child: const Row(
                  children: [
                    Text(
                      'Delete All',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Iconsax.trash_copy,
                      size: 20,
                      color: primaryColor,
                    )
                  ],
                ),
              )
            ],
          );
        } else {
          final TaskEntity task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 16;
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
    }
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<EditTaskCubit>(
              create: (context) => EditTaskCubit(
                widget.task,
                context.read<Repository<TaskEntity>>(),
              ),
              child: EditTaskScreen(),
            ),
          ));
        });
      },
      onLongPress: () {
        final repository =
            Provider.of<Repository<TaskEntity>>(context, listen: false);
        repository.delete(widget.task);
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(TaskItem.borderRadius),
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        height: TaskItem.height,
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 1, color: Colors.black.withOpacity(0.13)),
          ],
        ),
        child: Row(
          children: [
            CustomCheckBox(
              value: widget.task.isCompleted,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 5,
              height: TaskItem.height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(TaskItem.borderRadius),
                  bottomRight: Radius.circular(TaskItem.borderRadius),
                ),
                color: priorityColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
