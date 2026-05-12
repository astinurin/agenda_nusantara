import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'settings_screen.dart';
import 'add_normal_task_screen.dart';
import 'add_important_task_screen.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> daftarTask = [];
  String searchQuery = '';
  bool showSearchBar = false;
  String username = 'user';

  String get tanggalHariIni {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
  }

  Future<void> loadTasks() async {
    final data = await DatabaseHelper.instance.getSemuaTask();

    setState(() {
      daftarTask = data;
    });
  }

  Future<void> loadUsername() async {
    final savedUsername = await AuthService.getUsername();

    setState(() {
      username = savedUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
    loadUsername();
  }

  int get totalTask => daftarTask.length;

  int get totalSelesai => daftarTask.where((task) => task.isSelesai).length;

  int get totalBelum => daftarTask.where((task) => !task.isSelesai).length;

  int get selesaiHariIni {
    final hariIni = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return daftarTask.where((task) {
      if (task.tanggalSelesai == null) {
        return false;
      }

      final tanggalTask = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(task.tanggalSelesai!));

      return tanggalTask == hariIni;
    }).length;
  }

  double get progressHariIni {
    if (totalTask == 0) {
      return 0;
    }

    return selesaiHariIni / totalTask;
  }

  List<Task> get filteredTasks {
    if (searchQuery.isEmpty) {
      return daftarTask;
    }

    return daftarTask.where((task) {
      return task.judul.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  //ambil tugas penting yang belum selesai sm tugas biasa
  List<Task> get tugasPenting {
    return filteredTasks
        .where((task) => task.isPenting && !task.isSelesai)
        .toList();
  }

  List<Task> get tugasBiasa {
    return filteredTasks
        .where((task) => !task.isPenting && !task.isSelesai)
        .toList();
  }

  void toggleSearchBar() {
    setState(() {
      showSearchBar = !showSearchBar;

      if (!showSearchBar) {
        searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            'Halo, Selamat Datang!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),

                          SizedBox(height: 2),

                          Text(
                            username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3142),
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            tanggalHariIni,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B8B9C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    _buildIconButton(Icons.search, onTap: toggleSearchBar),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // body: const Center(
      //   child: Text('Home Screen'),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              height: showSearchBar ? 70 : 0,

              child: showSearchBar
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),

                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),

                            const SizedBox(width: 10),

                            Expanded(
                              child: TextField(
                                autofocus: true,

                                decoration: const InputDecoration(
                                  hintText: 'Cari tugas...',
                                  border: InputBorder.none,
                                ),

                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),
                            ),

                            GestureDetector(
                              onTap: toggleSearchBar,

                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                  color: Color(0xFF4ECDC4),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            if (searchQuery.isEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      angka: totalTask.toString(),
                      label: 'Total Tugas',
                      warna: const Color(0xFFFF8FAB),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildStatCard(
                      angka: totalSelesai.toString(),
                      label: 'Selesai',
                      warna: const Color(0xFF4ECDC4),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _buildStatCard(
                      angka: totalBelum.toString(),
                      label: 'Belum Selesai',
                      warna: const Color(0xFFFFD166),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Hari Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        Text(
                          '${(progressHariIni * 100).toInt()}%',
                          style: TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: LinearProgressIndicator(
                        value: progressHariIni,
                        minHeight: 10,
                        backgroundColor: Color(0xFFE9EDF2),
                        valueColor: AlwaysStoppedAnimation(Color(0xFF4ECDC4)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivitas Minggu Ini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      height: 140,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          ...List.generate(7, (index) {
                            final date = DateTime.now().subtract(
                              Duration(days: 6 - index),
                            );

                            final namaHari = DateFormat(
                              'EEE',
                              'id_ID',
                            ).format(date);

                            return _buildBarAktivitas(
                              getAktivitasMingguan(6 - index),
                              namaHari,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'Tugas Penting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              tugasPenting.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Text(
                          'Belum ada tugas penting',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: tugasPenting.map((task) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  task.isSelesai = !task.isSelesai;

                                  if (task.isSelesai) {
                                    task.tanggalSelesai = DateTime.now()
                                        .toIso8601String();
                                  } else {
                                    task.tanggalSelesai = null;
                                  }

                                  await DatabaseHelper.instance.updateTask(
                                    task,
                                  );

                                  loadTasks();
                                },

                                child: Container(
                                  width: 20,
                                  height: 20,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),

                                    border: Border.all(
                                      color: const Color(0xFFFF8FAB),
                                      width: 2,
                                    ),

                                    color: task.isSelesai
                                        ? const Color(0xFFFF8FAB)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      task.judul,

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,

                                        decoration: task.isSelesai
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      task.tanggal,

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 24),

              const Text(
                'Tugas Biasa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              tugasBiasa.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Text(
                          'Belum ada tugas biasa',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: tugasBiasa.map((task) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  task.isSelesai = !task.isSelesai;

                                  if (task.isSelesai) {
                                    task.tanggalSelesai = DateTime.now()
                                        .toIso8601String();
                                  } else {
                                    task.tanggalSelesai = null;
                                  }

                                  await DatabaseHelper.instance.updateTask(
                                    task,
                                  );

                                  loadTasks();
                                },

                                child: Container(
                                  width: 20,
                                  height: 20,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),

                                    border: Border.all(
                                      color: const Color(0xFF4ECDC4),
                                      width: 2,
                                    ),

                                    color: task.isSelesai
                                        ? const Color(0xFF4ECDC4)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      task.judul,

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,

                                        decoration: task.isSelesai
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      task.tanggal,

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],
            if (searchQuery.isNotEmpty) ...[
              const Text(
                'Hasil Pencarian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              filteredTasks.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Text(
                          'Tugas tidak ditemukan',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: filteredTasks.map((task) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  task.isSelesai = !task.isSelesai;

                                  if (task.isSelesai) {
                                    task.tanggalSelesai = DateTime.now()
                                        .toIso8601String();
                                  } else {
                                    task.tanggalSelesai = null;
                                  }

                                  await DatabaseHelper.instance.updateTask(
                                    task,
                                  );

                                  loadTasks();
                                },

                                child: Container(
                                  width: 20,
                                  height: 20,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),

                                    border: Border.all(
                                      color: task.isPenting
                                          ? const Color(0xFFFF8FAB)
                                          : const Color(0xFF4ECDC4),
                                      width: 2,
                                    ),

                                    color: task.isSelesai
                                        ? (task.isPenting
                                              ? const Color(0xFFFF8FAB)
                                              : const Color(0xFF4ECDC4))
                                        : Colors.transparent,
                                  ),

                                  child: task.isSelesai
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Icon(
                                task.isPenting
                                    ? Icons.star_rounded
                                    : Icons.assignment_rounded,

                                color: task.isPenting
                                    ? const Color(0xFFFF8FAB)
                                    : const Color(0xFF4ECDC4),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      task.judul,

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,

                                        decoration: task.isSelesai
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      task.tanggal,

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],

            // statistik
            const SizedBox(height: 100),
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
                      onTap: () async {
                        Navigator.pop(context);

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddImportantTaskScreen(),
                          ),
                        );

                        await loadTasks();

                        setState(() {});
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
                      onTap: () async {
                        Navigator.pop(context);

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddNormalTaskScreen(),
                          ),
                        );

                        await loadTasks();

                        setState(() {});
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
        currentIndex: 0,

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
            label: 'DaftarTugas',
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

  //hitung perhari
  double getAktivitasMingguan(int hariKeBelakang) {
    final targetDate = DateTime.now().subtract(Duration(days: hariKeBelakang));

    final target = DateFormat('yyyy-MM-dd').format(targetDate);

    final jumlah = daftarTask.where((task) {
      if (task.tanggalSelesai == null) {
        return false;
      }

      final tanggalTask = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(task.tanggalSelesai!));

      return tanggalTask == target;
    }).length;

    return jumlah * 20.0;
  }

  Widget _buildStatCard({
    required String angka,
    required String label,
    required Color warna,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),

      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: warna.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            angka,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarAktivitas(double tinggi, String hari) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: tinggi,

          decoration: BoxDecoration(
            color: const Color(0xFF9BE3DC),
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          hari,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 46,
        height: 46,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Icon(icon, color: const Color(0xFF2D3142)),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            isActive ? activeIcon : icon,

            size: 28,

            color: isActive ? const Color(0xFF4ECDC4) : const Color(0xFF4ECDC4),
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,

              color: isActive
                  ? const Color(0xFF4ECDC4)
                  : const Color(0xFF4ECDC4),
            ),
          ),
        ],
      ),
    );
  }
}
