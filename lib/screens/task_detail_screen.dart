import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;        // called when user deletes this task
  final VoidCallback onToggleComplete; // called when user marks complete/incomplete
  final VoidCallback onEdit;          // called when user wants to edit this task

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {

  // Returns the right color for the priority badge
  Color _priorityColor() {
    switch (widget.task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Returns the right icon for the category
  IconData _categoryIcon() {
    switch (widget.task.category) {
      case 'School':
        return Icons.school;
      case 'Personal':
        return Icons.person;
      case 'Health':
        return Icons.favorite;
      case 'Work':
        return Icons.work;
      default:
        return Icons.label;
    }
  }

  bool get _isOverdue {
    return !widget.task.isCompleted &&
        widget.task.dueDate.isBefore(DateTime.now());
  }

  // Shows a confirmation dialog before deleting
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);    // close the dialog
              widget.onDelete();         // remove from list
              Navigator.pop(context);    // go back to task list
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title + Priority badge ──────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _priorityColor()),
                  ),
                  child: Text(
                    task.priority,
                    style: TextStyle(
                      color: _priorityColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Status badge ────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.isCompleted ? '✅  Completed' : '⏳  Pending',
                style: TextStyle(
                  color: task.isCompleted
                      ? Colors.green.shade800
                      : Colors.orange.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // ── Detail rows ─────────────────────────────────────────
            _detailRow(Icons.description, 'Description', task.description),
            const Divider(),
            _detailRow(_categoryIcon(), 'Category', task.category),
            const Divider(),
            _detailRow(
              Icons.calendar_today,
              'Due Date',
              '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}'
                  '${_isOverdue ? '  ⚠️ Overdue' : ''}',
              valueColor: _isOverdue ? Colors.red : null,
            ),
            const Divider(),

            const SizedBox(height: 24),

            // ── Mark complete / incomplete ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onToggleComplete();
                  setState(() {}); // refresh this screen so badge updates
                },
                icon: Icon(task.isCompleted ? Icons.undo : Icons.check),
                label: Text(
                  task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      task.isCompleted ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Edit task ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Pop the detail screen first, then open the edit form on the list screen
                  Navigator.pop(context);
                  widget.onEdit();
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Task'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00ACC1),
                  side: const BorderSide(color: Color(0xFF00ACC1)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Delete task ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete),
                label: const Text('Delete Task'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a labelled info row
  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: valueColor ?? Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}