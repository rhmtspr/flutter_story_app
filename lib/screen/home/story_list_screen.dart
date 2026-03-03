import 'dart:async';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/provider/list_story_provider.dart';
import 'package:declarative_navigation/provider/list_story_result_state.dart';
import 'package:declarative_navigation/widgets/story_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListStoryScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const ListStoryScreen({
    super.key,
    required this.onTapped,
    required this.onLogout,
    required this.onAddStory,
  });

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
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // flat soft background
      appBar: AppBar(
        title: const Text('Stories'),
        centerTitle: true,
        elevation: 0, // flat
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed:
                authProvider.isLoadingLogout
                    ? null
                    : () async {
                      await context.read<AuthProvider>().logout();
                      widget.onLogout();
                    },
            icon:
                authProvider.isLoadingLogout
                    ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<ListStoryProvider>(
        builder: (context, provider, child) {
          final state = provider.resultState;

          if (state is ListStoryLoadingState) {
            return const _LoadingView();
          }

          if (state is ListStoryErrorState) {
            return _ErrorView(message: state.error, onRetry: _fetch);
          }

          if (state is ListStoryLoadedState) {
            final stories = state.data;

            if (stories.isEmpty) {
              return const _EmptyView();
            }

            return RefreshIndicator(
              onRefresh: _fetch,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StoryCard(
                      name: story.name,
                      description: story.description,
                      photoUrl: story.photoUrl,
                      createdAt: story.createdAt,
                      onTap: () => widget.onTapped(story.id),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.black,
        onPressed: widget.onAddStory,
        child: const Icon(Icons.add, color: Colors.white),
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
            Text("No stories found", style: text.titleMedium),
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
