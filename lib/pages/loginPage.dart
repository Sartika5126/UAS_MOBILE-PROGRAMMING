import 'package:flutter/material.dart';
import '../helper/loginHelper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'home_page.dart'; // Jangan lupa import halaman tujuanmu nanti

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();
  // 1. Controller untuk mengambil teks inputan
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // 2. Instance helper untuk koneksi ke API
  final LoginHelper loginHelper = LoginHelper();

 

  // 3. Variable status loading
  bool isLoading = false;

  // 4. WAJIB: Dispose controller agar tidak bocor memori (Memory Leak)
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Dulu Kuy'),
        backgroundColor: Colors.blueAccent, // Hiasan sedikit
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView( // Supaya bisa di-scroll kalau keyboard muncul
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Input Username ---
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                
                // --- Input Password ---
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true, // Sembunyikan password
                ),
                const SizedBox(height: 30),

                // --- Tombol Login ---
                SizedBox(
                  width: double.infinity, // Tombol selebar layar
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    // Jika sedang loading, tombol dimatikan (null)
                    onPressed: isLoading ? null : () async {
                      
                      // Cek dulu apakah inputan kosong
                      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Isi username dan password dulu dong!")),
                        );
                        return;
                      }

                      // Mulai Loading
                      setState(() {
                        isLoading = true;
                      });

                      // Panggil fungsi login dari Helper
                      // Pastikan di LoginHelper kamu mengirim key JSON "passwordHash" sesuai request backend!
                      final loginRequest = await loginHelper.login(
                        usernameController.text,
                        passwordController.text,
                      );

                      // Stop Loading
                      setState(() {
                        isLoading = false;
                      });

                      // Cek Hasil
                      if (loginRequest != null) {
                         await const FlutterSecureStorage().write(
                          key: 'token',
                          value: loginRequest.token,
                        );// Cek apakah halaman masih aktif

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login berhasil!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      Navigator.pushReplacementNamed(
                        context,
                        '/dashboard',
                        arguments: {
                          'role': loginRequest.user.role,
                          'token': loginRequest.token,
                        },
                      );

                        // --- PINDAH HALAMAN (Navigasi) ---
                        // Navigator.pushReplacement(
                        //   context, 
                        //   MaterialPageRoute(builder: (context) => const HomePage()),
                        // );
                        
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Username atau Password salah!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    // Tampilan Tombol: Kalau loading tampilkan putaran, kalau tidak tampilkan Teks
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}