import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  void login() async {
    final success = await AuthService.login(
      usernameController.text,
      passwordController.text,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        errorMessage = 'Username atau password salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),

            child: Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 38),

                  decoration: BoxDecoration(
                    color: const Color(0xFF83C9C3),
                    borderRadius: BorderRadius.circular(38),
                  ),

                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                        ),

                        child: const Icon(
                          Icons.task_alt_rounded,
                          color: Color(0xFF83C9C3),
                          size: 42,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'Agenda Nusantara',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Kelola tugas harianmu',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                // TITLE
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Selamat Datang 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Masuk untuk melanjutkan',
                    style: TextStyle(fontSize: 13, color: Color(0xFF7C7F93)),
                  ),
                ),

                const SizedBox(height: 26),

                // USN
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'USERNAME',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C7F93),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: usernameController,

                  decoration: InputDecoration(
                    hintText: 'masukkan username',

                    filled: true,
                    fillColor: const Color(0xFFF4F5F8),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),

                      borderSide: const BorderSide(
                        color: Color(0xFFE7E8ED),
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),

                      borderSide: const BorderSide(
                        color: Color(0xFF83C9C3),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // PASSWORD
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C7F93),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  decoration: InputDecoration(
                    hintText: 'masukkan password',

                    filled: true,
                    fillColor: const Color(0xFFF4F5F8),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),

                      borderSide: const BorderSide(
                        color: Color(0xFFE7E8ED),
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),

                      borderSide: const BorderSide(
                        color: Color(0xFF83C9C3),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

              

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF83C9C3),

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(vertical: 18),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    onPressed: login,

                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                

                const SizedBox(height: 24),

              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
