import 'dart:async';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/provider/list_story_provider.dart';
import 'package:declarative_navigation/provider/list_story_result_state.dart';
import 'package:declarative_navigation/widgets/empty_view.dart';
import 'package:declarative_navigation/widgets/error_view.dart';
import 'package:declarative_navigation/widgets/loading_view.dart';
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
            return const LoadingView();
          }

          if (state is ListStoryErrorState) {
            return ErrorView(message: state.error, onRetry: _fetch);
          }

          if (state is ListStoryLoadedState) {
            final stories = state.data;

            if (stories.isEmpty) {
              return const EmptyView();
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
                      photoUrl: story.photoUrl,
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
