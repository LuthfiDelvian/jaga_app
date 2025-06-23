import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> quickReplies = [
    'Bagaimana cara membuat laporan pertama kali?',
    'Apa saja jenis laporan yang bisa saya kirimkan?',
    'Apa perbedaan antara aduan, aspirasi, dan laporan gratifikasi?',
    'Bagaimana cara mengetahui status laporan saya?',
    'Berapa lama waktu verifikasi laporan?',
    'Bagaimana cara menghapus akun saya di aplikasi JAGA?',
    'Apa yang terjadi setelah laporan saya diverifikasi?',
    'Apakah laporan yang ditolak bisa diajukan ulang?',
  ];

  @override
  void initState() {
    super.initState();
    messages.add({
      'sender': 'bot',
      'text':
          'Halo! 👋 Selamat datang di JAGA Bot. Saya siap bantu kamu seputar pelaporan, status aduan, atau pertanyaan lainnya tentang aplikasi JAGA. Pilih pertanyaan yang ingin kamu tanyakan, ya!',
    });
  }

  void _onQuickReplyTapped(String reply) {
    _addUserMessage(reply);
    _addBotReply(reply);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _addBotReply(text);

    _controller.clear();
  }

  void _addUserMessage(String text) {
    setState(() {
      messages.add({'sender': 'user', 'text': text});
    });
    _scrollToBottom();
  }

  void _addBotReply(String userInput) {
    final reply = _botReply(userInput);
    setState(() {
      messages.add({'sender': 'bot', 'text': reply});
    });
    _scrollToBottom();
  }

  String _botReply(String input) {
    if (input.contains('diverifikasi')) {
      return 'Setelah laporan kamu diverifikasi, laporan akan diproses oleh pihak berwenang sesuai kategori dari isi laporan. Kamu bisa memantau statusnya di aplikasi JAGA.';
    }
    return 'Terima kasih atas pertanyaannya. Mohon tunggu informasi selanjutnya dari JAGA Bot.';
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/jaga-icon.png',
              height: 100,
              color: Colors.white,
            ),
            Text(
              'BOT',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';

                // Pesan pertama bot + quick replies
                if (index == 0 && message['sender'] == 'bot') {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message['text'] ?? ''),
                          SizedBox(height: 8),
                          Divider(color: Colors.grey.shade300),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                quickReplies.map((reply) {
                                  return GestureDetector(
                                    onTap: () => _onQuickReplyTapped(reply),
                                    child: Text(
                                      reply,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Chat bubble lainnya
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.white,
                      border: isUser ? null : Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['text'] ?? ''),
                  ),
                );
              },
            ),
          ),

          // Input dengan border dan tombol kirim
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan...',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.send, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
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
