import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import 'add_normal_task_screen.dart';
import 'add_important_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> daftarTask = [];
  String selectedFilter = 'Semua';

  Future<void> loadTasks() async {
    final data = await DatabaseHelper.instance.getSemuaTask();

    setState(() {
      daftarTask = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  List<Task> get filteredTasks {
    if (selectedFilter == 'Semua') {
      return daftarTask;
    }

    if (selectedFilter == 'Penting') {
      return daftarTask.where((task) => task.isPenting).toList();
    }

    if (selectedFilter == 'Biasa') {
      return daftarTask.where((task) => !task.isPenting).toList();
    }

    if (selectedFilter == 'Selesai') {
      return daftarTask.where((task) => task.isSelesai).toList();
    }

    return daftarTask.where((task) => !task.isSelesai).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFF2D3142),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),

        title: const Text(
          'Daftar Tugas',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Column(
          children: [
            const SizedBox(height: 10),

            // FILTER
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  _buildFilterButton('Semua'),
                  _buildFilterButton('Penting'),
                  _buildFilterButton('Biasa'),
                  _buildFilterButton('Selesai'),
                  _buildFilterButton('Belum'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TASK LIST
            Expanded(
              child: filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: filteredTasks.length,

                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return _buildTaskCard(task);
                      },
                    ),
            ),
          ],
        ),
      ),

      //btn tambah tugas
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4ECDC4),
        elevation: 8,

        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,

            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),

                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEF2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddImportantTaskScreen(),
                          ),
                        ).then((_) {
                          loadTasks();
                        });
                      },

                      child: Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8FAB).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,

                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8FAB),
                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 16),

                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Tugas Penting',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Prioritas utama',
                                  style: TextStyle(color: Color(0xFF7C7F93)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddNormalTaskScreen(),
                          ),
                        ).then((_) {
                          loadTasks();
                        });
                      },

                      child: Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,

                              decoration: BoxDecoration(
                                color: const Color(0xFF4ECDC4),
                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: const Icon(
                                Icons.assignment_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 16),

                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Tugas Biasa',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Aktivitas harian',
                                  style: TextStyle(color: Color(0xFF7C7F93)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },

        child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,

        selectedItemColor: const Color(0xFF4ECDC4),
        unselectedItemColor: const Color(0xFFBFC3D4),

        backgroundColor: Colors.white,

        type: BottomNavigationBarType.fixed,

        elevation: 0,

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TaskListScreen()),
            );
          }

          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Tugas',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    final isActive = selectedFilter == title;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = title;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4ECDC4) : Colors.white,

            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF7C7F93),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              task.isSelesai = !task.isSelesai;

              if (task.isSelesai) {
                task.tanggalSelesai = DateTime.now().toIso8601String();
              } else {
                task.tanggalSelesai = null;
              }

              await DatabaseHelper.instance.updateTask(task);

              loadTasks();
            },

            child: Container(
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                color: task.isSelesai
                    ? const Color(0xFF4ECDC4)
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(8),

                border: Border.all(
                  color: task.isSelesai
                      ? const Color(0xFF4ECDC4)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),

              child: task.isSelesai
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,

                      decoration: BoxDecoration(
                        color: task.isPenting
                            ? const Color(0xFFFF8FAB)
                            : const Color(0xFF4ECDC4),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        task.judul,

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,

                          decoration: task.isSelesai
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,

                          color: task.isSelesai
                              ? Colors.grey
                              : const Color(0xFF2D3142),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: task.isPenting
                            ? const Color(0xFFFFEEF3)
                            : const Color(0xFFE8FFFC),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        task.isPenting ? 'Penting' : 'Biasa',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: task.isPenting
                              ? const Color(0xFFFF8FAB)
                              : const Color(0xFF4ECDC4),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      '🕐 ${task.tanggal}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7C7F93),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () async {
              await DatabaseHelper.instance.hapusTask(task.id!);

              loadTasks();
            },

            child: Container(
              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF3),
                borderRadius: BorderRadius.circular(12),
              ),

              child: const Icon(Icons.delete_outline, color: Color(0xFFFF8FAB)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: const [
          Text('📭', style: TextStyle(fontSize: 52)),

          SizedBox(height: 14),

          Text(
            'Belum ada tugas di sini',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C7F93),
            ),
          ),
        ],
      ),
    );
  }
}
