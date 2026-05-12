import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'task_list_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String username = 'user';

  @override
  void initState() {
    super.initState();

    loadUsername();
  }

  Future<void> loadUsername() async {
    final savedUsername = await AuthService.getUsername();

    setState(() {
      username = savedUsername;
    });
  }

  Future<void> editUsername() async {
    final controller = TextEditingController(text: username);

    await showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),

          content: TextField(
            controller: controller,

            decoration: const InputDecoration(
              hintText: 'Masukkan username baru',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () async {
                final password = await AuthService.getPassword();

                await AuthService.updateAccount(controller.text, password);

                loadUsername();

                Navigator.pop(context);
              },

              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  //edit pw
  Future<void> editPassword() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Ganti Password'),

          content: TextField(
            controller: controller,
            obscureText: true,

            decoration: const InputDecoration(
              hintText: 'Masukkan password baru',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () async {
                final username = await AuthService.getUsername();

                await AuthService.updateAccount(username, controller.text);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password berhasil diubah')),
                );
              },

              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },

                    child: Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PROFILE CARD
              Container(
                padding: const EdgeInsets.all(20),

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

                child: Row(
                  children: [
                    

                  

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3142),
                          ),
                        ),

                        SizedBox(height: 4),

                        // Text(
                        //   'asti@email.com',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: Color(0xFF7C7F93),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // AKUN
              const Text(
                'Akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                ),
              ),

              const SizedBox(height: 10),

              _buildSettingItem(
                onTap: editUsername,
                icon: Icons.person_outline_rounded,
                title: 'Edit Username',
                iconBg: const Color(0xFFC7F5F2),
                iconColor: const Color(0xFF4ECDC4),
              ),

              const SizedBox(height: 10),

              _buildSettingItem(
                onTap: editPassword,

                icon: Icons.lock_outline_rounded,
                title: 'Ganti Password',
                iconBg: const Color(0xFFFFD6E0),
                iconColor: const Color(0xFFFF8FAB),
              ),

              const SizedBox(height: 26),

              // PREFERENSI

              // LOGOUT
              SizedBox(
                width: double.infinity,

                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    side: const BorderSide(color: Color(0xFFFF8FAB)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(builder: (_) => const LoginScreen()),

                      (route) => false,
                    );
                  },

                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Color(0xFFFF8FAB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFEDE8FF),

                      child: Text(
                        'A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: const [
                        Text(
                          'Asti Nurin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text('NIM 2241720236', style: TextStyle(color: Colors.grey)),

                        SizedBox(height: 4),

                        Text(
                          'Developer Aplikasi',
                          style: TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,

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

  Widget _buildSettingItem({
    VoidCallback? onTap,
    required IconData icon,
    required String title,
    required Color iconBg,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon, color: iconColor),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF2D3142),
                ),
              ),
            ),

            const Icon(Icons.chevron_right_rounded, color: Color(0xFFBFC3D4)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

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
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF2D3142),
              ),
            ),
          ),

          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: const Color(0xFF4ECDC4),
          ),
        ],
      ),
    );
  }
}
