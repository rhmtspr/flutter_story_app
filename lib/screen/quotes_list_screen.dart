import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.onLogout,
    required this.onAddStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes App"),
        actions: [
          IconButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              await authRead.logout();
              onLogout();
            },
            tooltip: 'Logout',
            icon:
                authWatch.isLoadingLogout
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var quote in quotes)
            ListTile(
              title: Text(quote.author),
              subtitle: Text(quote.quote),
              isThreeLine: true,
              onTap: () => onTapped(quote.id),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddStory(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
