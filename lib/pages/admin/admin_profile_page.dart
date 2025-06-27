import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? user;
  late Box<AppUser> userBox;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    userBox = Hive.box<AppUser>('users');
    final fetchedUser = userBox.get(widget.userId);
    setState(() {
      user = fetchedUser;
    });
  }

  void _showDeleteConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Hapus permanent akun user?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (user != null) {
                      final boxName = 'habits_${user!.username}';

                      // Coba close hanya jika box terbuka dan bertipe Box<Habit>
                      if (Hive.isBoxOpen(boxName)) {
                        final box = Hive.box(boxName);
                        // Hindari close jika box masih digunakan aktif oleh widget lain
                        await box.close();
                      }

                      // Hapus box dari disk jika sudah tidak aktif
                      if (await Hive.boxExists(boxName)) {
                        await Hive.deleteBoxFromDisk(boxName);
                      }

                      // Hapus user dari box
                      await user!.delete();
                    }

                    Navigator.pop(context); // tutup bottom sheet
                    Navigator.pop(context); // kembali ke halaman sebelumnya

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Akun berhasil dihapus')),
                    );
                  },
                  child: const Text(
                    'Hapus',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFD3EBFD),
                  child: Image.asset('assets/avatar.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user!.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: const Color(0xFFF6F8FA),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow("FULL NAME", user!.fullName, 'ic_avatar'),
                  _buildInfoRow("EMAIL", user!.email, 'ic_email'),
                  _buildInfoRow("PHONE NUMBER", user!.phoneNumber, 'ic_phone'),
                  _buildInfoRow("ROLE", user!.role, 'ic_avatar'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 2),
            GestureDetector(
              onTap: _showDeleteConfirmationDialog,
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.black),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hapus akun",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Akun ini akan dihapus permanent\nTidak bisa diakses kembali.",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconAsset) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Image.asset('assets/$iconAsset.png', width: 32),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
