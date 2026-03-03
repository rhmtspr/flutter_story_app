import 'dart:async';

import 'package:declarative_navigation/provider/list_story_provider.dart';
import 'package:declarative_navigation/provider/list_story_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListStoryScreen extends StatefulWidget {
  final Function(String) onTapped;

  const ListStoryScreen({super.key, required this.onTapped});

  @override
  State<ListStoryScreen> createState() => _ListStoryScreenState();
}

class _ListStoryScreenState extends State<ListStoryScreen> {
  Future<void> _fetch() async {
    await context.read<ListStoryProvider>().fetchListStory();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories'), centerTitle: true),
      body: Consumer<ListStoryProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            ListStoryLoadingState() => const _LoadingView(),
            ListStoryLoadedState(data: var listStory) => RefreshIndicator(
              onRefresh: _fetch,
              child:
                  listStory.isEmpty
                      ? const _EmptyView()
                      : ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text('Discover Stories'),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listStory.length,
                            itemBuilder: (context, index) {
                              final story = listStory[index];

                              return ListTile(
                                title: Text(story.name),
                                onTap: () => widget.onTapped(story.id),
                              );
                            },
                          ),
                        ],
                      ),
            ),
            ListStoryErrorState(error: var message) => _ErrorView(
              message: message,
              onRetry: _fetch,
            ),

            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 48, color: colors.outline),
            const SizedBox(height: 12),
            Text("No restaurants found", style: text.titleMedium),
            const SizedBox(height: 6),
            Text(
              "Try refreshing or search something else",
              style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text("Try again")),
          ],
        ),
      ),
    );
  }
}
