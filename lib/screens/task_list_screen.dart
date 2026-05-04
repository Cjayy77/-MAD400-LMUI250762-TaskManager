import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = []; 

  String _filter = 'All';   
  String _sortBy = 'None';   
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // ── Computed list: filter + search + sort applied ─────────────────────────
  List<Task> get _filteredTasks {
    List<Task> result = List.from(_tasks);

    // 1. Filter by completion status
    if (_filter == 'Pending') {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      result = result.where((t) => t.isCompleted).toList();
    }

    // 2. Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // 3. Sort
    if (_sortBy == 'DueDate') {
      result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortBy == 'Priority') {
      const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      result.sort(
        (a, b) => (priorityOrder[a.priority] ?? 1)
            .compareTo(priorityOrder[b.priority] ?? 1),
      );
    }

    return result;
  }

  // ── Quick stats ───────────────────────────────────────────────────────────
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _tasks.where((t) => !t.isCompleted).length;

  // ── Mutating the task list ────────────────────────────────────────────────
  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _toggleComplete(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  // ── Bottom sheet for adding / editing a task ──────────────────────────────
  
  void _showTaskForm({Task? taskToEdit}) {
    final titleController =
        TextEditingController(text: taskToEdit?.title ?? '');
    final descController =
        TextEditingController(text: taskToEdit?.description ?? '');
    String selectedCategory = taskToEdit?.category ?? 'School';
    String selectedPriority = taskToEdit?.priority ?? 'Medium';
    DateTime? selectedDate = taskToEdit?.dueDate;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
             
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskToEdit == null ? 'Add New Task' : 'Edit Task',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title field
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Description field
                      TextFormField(
                        controller: descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Description is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: ['School', 'Personal', 'Health', 'Work']
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() => selectedCategory = value!);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Priority dropdown
                      DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Low', 'Medium', 'High']
                            .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() => selectedPriority = value!);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Due date picker
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? 'No due date selected'
                                  : 'Due: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              // showDatePicker opens the system date picker
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setSheetState(() => selectedDate = picked);
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Pick Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // validate() checks all the form validators above
                            if (!formKey.currentState!.validate()) return;

                            if (selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please pick a due date')),
                              );
                              return;
                            }

                            if (taskToEdit == null) {
                              // Adding a brand new task
                              _addTask(Task(
                                title: titleController.text,
                                description: descController.text,
                                category: selectedCategory,
                                priority: selectedPriority,
                                dueDate: selectedDate!,
                              ));
                            } else {
                              // Editing an existing task — just update its fields
                            
                              setState(() {
                                taskToEdit.title = titleController.text;
                                taskToEdit.description = descController.text;
                                taskToEdit.category = selectedCategory;
                                taskToEdit.priority = selectedPriority;
                                taskToEdit.dueDate = selectedDate!;
                              });
                            }

                            Navigator.pop(context); // close the bottom sheet
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0067C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            taskToEdit == null ? 'Add Task' : 'Save Changes',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Sort options bottom sheet ──────────────────────────────────────────────
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Sort by Due Date'),
              onTap: () {
                setState(() => _sortBy = 'DueDate');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Sort by Priority'),
              onTap: () {
                setState(() => _sortBy = 'Priority');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Remove Sorting'),
              onTap: () {
                setState(() => _sortBy = 'None');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ── Confirm before deleting all tasks ────────────────────────────────────
  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('This will delete all tasks. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _tasks.clear());
              Navigator.pop(context);
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;
    final progress =
        _tasks.isEmpty ? 0.0 : _completedCount / _tasks.length;

    return Scaffold(
      appBar: AppBar(
        // When searching, show a text field instead of the title
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              )
            : const Text('My Tasks'),
        actions: [
          // Toggle search on/off
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Sort icon
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
          // Clear all icon
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _confirmClearAll,
          ),
        ],
      ),

      body: Column(
        children: [

          // ── Stats bar ───────────────────────────────────────────────────
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('Total', _tasks.length, Colors.blueGrey),
                    _statItem('Completed', _completedCount, Colors.green),
                    _statItem('Pending', _pendingCount, Colors.orange),
                  ],
                ),
                const SizedBox(height: 8),
                // LinearProgressIndicator shows completion percentage
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF0067C0),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% completed',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ── Filter chips ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: const Color(0xFF0067C0).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF0067C0),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF0067C0)
                          : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Task list or empty state ─────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist,
                          size: 70,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _tasks.isEmpty
                              ? 'No tasks yet!\nTap + to add your first one.'
                              : 'No tasks match this filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final task = filtered[index];
                      return Dismissible(
                        // Key must be unique — we combine title and date
                        key: ValueKey('${task.title}_${task.dueDate}'),
                        direction: DismissDirection.endToStart, // swipe left
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTask(task),
                        child: TaskCard(
                          task: task,
                          onTap: () async {
                            // Navigate to detail screen and wait for it to return
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(
                                  task: task,
                                  onDelete: () => _deleteTask(task),
                                  onToggleComplete: () =>
                                      _toggleComplete(task),
                                  // onEdit pops the detail screen then opens the form here
                                  onEdit: () =>
                                      _showTaskForm(taskToEdit: task),
                                ),
                              ),
                            );
                            // Refresh the list when we come back
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // + button to open the add task form
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper widget for a stat column (number + label)
  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
