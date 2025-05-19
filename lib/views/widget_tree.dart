import 'package:flutter/material.dart';
import 'package:jaga_app/data/notifiers.dart';
import 'package:jaga_app/views/pages/home_page.dart';
import 'package:jaga_app/views/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.comment),
          color: Colors.amber,
          onPressed: () {},
        ),
        title: Icon(Icons.person, color: Colors.purple),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.red),
            onPressed: () {},
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
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
