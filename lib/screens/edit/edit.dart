import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/main.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: context.read<EditTaskCubit>().state.task.name,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.primary,
        foregroundColor: themeData.colorScheme.onPrimary,
        title: const Text(
          'Edit Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<EditTaskCubit>().onSaveChangesClick();
          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Text('Save Changes'),
            SizedBox(
              width: 10,
            ),
            Icon(Iconsax.receive_square),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        label: 'High',
                        color: highPriority,
                        isSelected: priority == Priority.high,
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.high);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        label: 'Normal',
                        color: normalPriority,
                        isSelected: priority == Priority.normal,
                        onTap: () {
                          context
                              .read<EditTaskCubit>()
                              .onPriorityChanged(Priority.normal);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: PriorityCheckBox(
                        label: 'Low',
                        color: lowPriority,
                        isSelected: priority == Priority.low,
                        onTap: () {
                          setState(() {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Priority.low);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChanged(value);
              },
              decoration: InputDecoration(
                label: Text(
                  'Add New Task For To Day...',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(fontSizeFactor: 1.3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondyTextColor.withOpacity(0.20),
          ),
        ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
              right: 6,
              top: 0,
              bottom: 0,
              child: Center(
                child: CustomCheckBoxPriority(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckBoxPriority extends StatelessWidget {
  final bool value;
  final Color color;

  const CustomCheckBoxPriority({
    super.key,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 12,
              )
            : null);
  }
}
