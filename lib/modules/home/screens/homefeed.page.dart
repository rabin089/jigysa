import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/modules/ideas/cubit/ideas_cubit.dart';
import 'package:jigyasa/modules/ideas/cubit/ideas_state.dart';
import 'package:jigyasa/modules/ideas/widgets/idea_card.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IdeasCubit()..fetchAll(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover Ideas'),
          centerTitle: false,
        ),
        body: BlocBuilder<IdeasCubit, IdeasState>(
          builder: (context, state) {
            if (state is IdeasLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is IdeasError) {
              return Center(child: Text('Failed: ${state.message}'));
            }
            if (state is IdeasLoaded) {
              if (state.ideas.isEmpty) {
                return const Center(child: Text('No ideas yet'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: state.ideas.length,
                itemBuilder: (context, idx) {
                  final idea = state.ideas[idx];
                  return IdeaCard(idea: idea);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
