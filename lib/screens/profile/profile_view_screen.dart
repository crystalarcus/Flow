import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/account.dart';
import 'package:redesigned/screens/profile/profile_view_screen_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileViewScreen extends StatelessWidget {
  final Account account;
  final String postId;

  const ProfileViewScreen({
    super.key,
    required this.account,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewScreenModel(account),
      child: _ProfileViewScreenContent(postId: postId),
    );
  }
}

class _ProfileViewScreenContent extends StatelessWidget {
  final String postId;

  const _ProfileViewScreenContent({required this.postId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewScreenModel>();
    final account = viewModel.account;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(account.person.userName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Hero(
                    tag: 'pfp_$postId',
                    child: MaterialShapes.pentagon(
                      color: Colors.transparent,
                      size: 100,
                      imageFit: BoxFit.cover,
                      image: CachedNetworkImageProvider(account.person.pfpPath),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.person.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Hero(
                          tag: 'following_$postId',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimaryContainer,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.done,
                                      color: colorScheme.inversePrimary, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      color: colorScheme.inversePrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  account.bio,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Placeholder for posts grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Container(
                  color: colorScheme.surfaceContainerHigh,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
