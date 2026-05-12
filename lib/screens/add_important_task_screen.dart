import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class AddImportantTaskScreen extends StatefulWidget {
  const AddImportantTaskScreen({super.key});

  @override
  State<AddImportantTaskScreen> createState() => _AddImportantTaskScreenState();
}

class _AddImportantTaskScreenState extends State<AddImportantTaskScreen> {
  DateTime? selectedDate;

  //controller untuk input tugass
  final TextEditingController judulController = TextEditingController();

  final TextEditingController deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.all(8),

          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
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
        ),

        title: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8FAB), Color(0xFFE07AA0)],
                ),

                borderRadius: BorderRadius.circular(24),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.star_border_rounded,
                    color: Colors.white,
                    size: 36,
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Tugas Penting',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Ditandai untuk diselesaikan lebih dulu',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('Judul Tugas'),

            const SizedBox(height: 8),

            _buildInput(
              hint: 'Contoh: Kerjakan sertifikasi',
              controller: judulController,
            ),

            const SizedBox(height: 18),

            _buildLabel('Deskripsi'),

            const SizedBox(height: 8),

            TextField(
              controller: deskripsiController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: 'Tambahkan detail tugas...',
                

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.all(18),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEF2),
                    width: 2,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFE07AA0),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            _buildLabel('Tanggal'),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  locale: const Locale('id'),
                  initialDate: selectedDate ?? DateTime.now(),

                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),

                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFFF8FAB),
                          onPrimary: Colors.white,

                          surface: Colors.white,
                          onSurface: Color(0xFF2D3142),
                        ),

                        dialogTheme: DialogThemeData(
                          backgroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),

                        datePickerTheme: DatePickerThemeData(
                          backgroundColor: Colors.white,
                          dividerColor: Colors.transparent,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),

                          dayShape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          todayBorder: const BorderSide(
                            color: Color(0xFFFF8FAB),
                            width: 2,
                          ),

                          dayForegroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.white;
                            }

                            return const Color(0xFF2D3142);
                          }),

                          headerBackgroundColor: Colors.white,
                          headerForegroundColor: Color(0xFF2D3142),
                        ),
                      ),

                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: const Color(0xFFEEEEF2), width: 2),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      selectedDate == null
                          ? 'Pilih tanggal'
                          : DateFormat(
                              'd MMMM yyyy',
                              'id_ID',
                            ).format(selectedDate!),

                      style: TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.w700,

                        color: selectedDate == null
                            ? const Color(0xFF7C7F93)
                            : const Color(0xFF2D3142),
                      ),
                    ),

                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),

                      side: const BorderSide(
                        color: Color(0xFFEEEEF2),
                        width: 2,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Color(0xFF7C7F93),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8FAB),

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(vertical: 18),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () async {
                      if (judulController.text.isEmpty ||
                          deskripsiController.text.isEmpty ||
                          selectedDate == null) {
                        return;
                      }

                      final task = Task(
                        judul: judulController.text,
                        deskripsi: deskripsiController.text,

                        tanggal: DateFormat(
                          'd MMMM yyyy',
                          'id_ID',
                        ).format(selectedDate!),

                        isPenting: true,
                      );

                      await DatabaseHelper.instance.tambahTask(task);

                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Simpan Tugas',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Color(0xFF7C7F93),
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFEEEEF2), width: 2),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE07AA0), width: 2),
        ),
      ),
    );
  }
}
