import 'package:flutter/material.dart';
import 'package:jaga_app/data/notifiers.dart';
import 'package:jaga_app/views/pages/articles_page.dart';
import 'package:jaga_app/views/pages/chat_page.dart';
import 'package:jaga_app/views/pages/form_page.dart';
import 'package:jaga_app/views/pages/home_page.dart';
import 'package:jaga_app/views/pages/more_page.dart';
import 'package:jaga_app/views/pages/notifications_page.dart';
import 'package:jaga_app/views/pages/settings_page.dart';
import 'package:jaga_app/views/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), ArticlesPage(), FormPage(), MorePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.comment),
          color: Colors.amber,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatPage();
                },
              ),
            );
          },
        ),
        title: Icon(Icons.person, color: Colors.purple),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationsPage();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.grey,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
