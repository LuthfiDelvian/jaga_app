import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaga_app/app/layout/widget_tree.dart';
import 'package:jaga_app/app/services/auth_service.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hidePassword = true;
  bool _agreement = false;
  bool _isGenerating = false;
  bool _accountCreated = false;
  String? _generatedId;
  // ignore: unused_field
  String? _generatedEmail;
  String? _generatedPassword;
  String? _errorMsg;

  // Login controllers
  final idLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();

  final _authService = UserAuthService();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    idLoginController.dispose();
    passwordLoginController.dispose();
    super.dispose();
  }

  // Handle login
  Future<void> _loginUser() async {
    setState(() {
      _errorMsg = null;
    });
    if (idLoginController.text.trim().isEmpty ||
        passwordLoginController.text.isEmpty) {
      setState(() {
        _errorMsg = "ID dan Kata Sandi wajib diisi";
      });
      return;
    }
    try {
      await _authService.signInWithIdAndPassword(
        id: idLoginController.text.trim(),
        password: passwordLoginController.text,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WidgetTree()),
        (route) => false,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login sukses!')));
    } catch (e) {
      setState(() {
        _errorMsg = "ID atau Kata Sandi salah";
      });
    }
  }

  // Handle register
  Future<void> _generateAccount() async {
    setState(() {
      _isGenerating = true;
      _generatedId = null;
      _generatedPassword = null;
      _accountCreated = false;
      _errorMsg = null;
    });
    try {
      final result = await _authService.registerAnonymousAccount();
      setState(() {
        _generatedId = result['id'];
        _generatedEmail = result['email'];
        _generatedPassword = result['password'];
        _accountCreated = true;
      });
    } catch (e) {
      setState(() {
        _errorMsg = "Gagal membuat akun, coba lagi";
      });
    }
    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset('assets/images/jaga-icon.png', height: 100),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: const [Tab(text: "Masuk"), Tab(text: "Buat ID Akun")],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ------------- TAB MASUK ----------------
                  SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            TextField(
                              controller: idLoginController,
                              decoration: const InputDecoration(
                                hintText: 'ID Akun',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: passwordLoginController,
                              obscureText: _hidePassword,
                              decoration: InputDecoration(
                                hintText: 'Kata Sandi',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_errorMsg != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _errorMsg!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: _loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size.fromHeight(45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ------------- TAB BUAT ID AKUN --------------
                  SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_accountCreated) ...[
                              // Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _agreement,
                                    onChanged: (v) {
                                      setState(() => _agreement = v!);
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Saya memahami bahwa akun ini bersifat anonim dan akun akan dihapus otomatis jika tidak aktif selama 7 hari. Laporan yang telah dikirim dan diverifikasi tetap tersimpan di sistem admin.',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (_errorMsg != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    _errorMsg!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              // Tombol Buat ID
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      (!_agreement || _isGenerating)
                                          ? null
                                          : _generateAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size.fromHeight(45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:
                                      _isGenerating
                                          ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                          : const Text(
                                            'Buat ID Akun',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                ),
                              ),
                            ] else ...[
                              // Jika akun sudah dibuat
                              const SizedBox(height: 12),
                              const Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Center(
                                child: Text(
                                  'Akun telah dibuat',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text(
                                    'ID Akun',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 18),
                                    onPressed: () {
                                      if (_generatedId != null) {
                                        Clipboard.setData(
                                          ClipboardData(text: _generatedId!),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('ID Akun disalin'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _generatedId ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    'Kata Sandi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 18),
                                    onPressed: () {
                                      if (_generatedPassword != null) {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: _generatedPassword!,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Kata sandi disalin'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _generatedPassword ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Catat atau salin informasi ini. Kami tidak menyimpan salinan ID dan kata sandi Anda.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    idLoginController.text = _generatedId ?? '';
                                    passwordLoginController.text =
                                        _generatedPassword ?? '';
                                    setState(() {
                                      _tabController.animateTo(0);
                                      _accountCreated = false;
                                      _agreement = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size.fromHeight(45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
