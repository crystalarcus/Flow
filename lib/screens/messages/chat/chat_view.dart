import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/chat.dart';
import 'package:redesigned/screens/messages/chat/chat_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 840) {
          return const DesktopChatView();
        } else {
          return const MobileChatView();
        }
      },
    );
  }
}

class MobileChatView extends StatelessWidget {
  const MobileChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final person = viewModel.person;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () => viewModel.onBackPress(context),
            icon: const Icon(Icons.arrow_back)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.8,
                    color: person.isStoryVisible
                        ? person.newStory
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                    height: 45,
                    width: 45,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    fit: BoxFit.contain,
                    imageUrl: person.profilePicturePath),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  person.userName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ScrollablePositionedList.builder(
                reverse: true,
                itemScrollController: viewModel.scrollController,
                itemCount: viewModel.chats.length,
                itemBuilder: (context, index) {
                  final chat = viewModel.chats[index];
                  if (chat.sentByUser) {
                    return UserChat(
                      onLongPress: () {},
                      isTopSame: index < viewModel.chats.length - 1 &&
                          viewModel.chats[index + 1].sentByUser,
                      chatText: chat,
                    );
                  } else {
                    return InterlocutorChat(
                      isBottomSame:
                          index > 1 && !viewModel.chats[index - 1].sentByUser,
                      pfpPath: person.profilePicturePath,
                      chatText: chat,
                      isTopSame: index < viewModel.chats.length - 1 &&
                          !viewModel.chats[index + 1].sentByUser,
                    );
                  }
                }),
          )),
          _buildInput(context, viewModel)
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, ChatViewModel viewModel) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(6),
            child: SizedBox(
                height: 56,
                child: TextField(
                  onChanged: viewModel.onInputChanged,
                  controller: viewModel.textEditingController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHigh,
                      isDense: true,
                      hintText: "Message...",
                      hintStyle: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt, size: 24)),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file_outlined,
                                size: 24),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined,
                                size: 24),
                          ),
                          viewModel.currentInput.isEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.mic, size: 24),
                                )
                              : IconButton(
                                  onPressed: viewModel.sendMessage,
                                  icon:
                                      const Icon(Icons.send_outlined, size: 24),
                                ),
                          const SizedBox(width: 4)
                        ],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)),
                ))));
  }
}

class DesktopChatView extends StatelessWidget {
  const DesktopChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final person = viewModel.person;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 64,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.8,
                    color: person.isStoryVisible
                        ? person.newStory
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                    height: 36,
                    width: 36,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    fit: BoxFit.contain,
                    imageUrl: person.profilePicturePath),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  person.userName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ScrollablePositionedList.builder(
                reverse: true,
                itemScrollController: viewModel.scrollController,
                itemCount: viewModel.chats.length,
                itemBuilder: (context, index) {
                  final chat = viewModel.chats[index];
                  if (chat.sentByUser) {
                    return UserChat(
                      onLongPress: () {},
                      isTopSame: index < viewModel.chats.length - 1 &&
                          viewModel.chats[index + 1].sentByUser,
                      chatText: chat,
                    );
                  } else {
                    return InterlocutorChat(
                      isBottomSame:
                          index > 1 && !viewModel.chats[index - 1].sentByUser,
                      pfpPath: person.profilePicturePath,
                      chatText: chat,
                      isTopSame: index < viewModel.chats.length - 1 &&
                          !viewModel.chats[index + 1].sentByUser,
                    );
                  }
                }),
          )),
          _buildInput(context, viewModel)
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, ChatViewModel viewModel) {
    return Padding(
        padding: const EdgeInsets.all(6),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: TextField(
              maxLines: null,
              onChanged: viewModel.onInputChanged,
              controller: viewModel.textEditingController,
              decoration: InputDecoration(
                  filled: true,
                  isDense: false,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  hintText: "Message...",
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, size: 24)),
                  suffixIcon: viewModel.currentInput.isEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file_outlined,
                                  size: 24),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.emoji_emotions_outlined,
                                  size: 24),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mic, size: 24),
                            ),
                            const SizedBox(width: 4)
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextButton(
                              onPressed: viewModel.sendMessage,
                              child: const Text(
                                "Send",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
            )));
  }
}

class InterlocutorChat extends StatelessWidget {
  const InterlocutorChat({
    super.key,
    required this.chatText,
    required this.isTopSame,
    required this.pfpPath,
    required this.isBottomSame,
  });
  final ChatText chatText;
  final String pfpPath;
  final bool isTopSame;
  final bool isBottomSame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isTopSame ? 2 : 16),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !isTopSame
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                          height: 36,
                          width: 36,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                          imageUrl: pfpPath),
                    )
                  : const SizedBox(width: 36),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isTopSame ? 2 : 8),
                  if (chatText.repliedTo != null)
                    ReplyWidget(reply: "Replied message"), // Placeholder
                  SizedBox(height: chatText.repliedTo != null ? 4 : 0),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 120),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: isBottomSame
                                ? const Radius.circular(8)
                                : const Radius.circular(24),
                            topLeft: const Radius.circular(8),
                            topRight: const Radius.circular(24),
                            bottomRight: const Radius.circular(24),
                          ),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                      child: Text(
                        chatText.text,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )
            ])
      ],
    );
  }
}

class UserChat extends StatelessWidget {
  const UserChat(
      {super.key,
      required this.chatText,
      required this.isTopSame,
      required this.onLongPress});
  final ChatText chatText;
  final bool isTopSame;
  final void Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: isTopSame ? 2 : 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 120),
              child: MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      trailingIcon: const Icon(Symbols.reply),
                      child: const Text("Reply"),
                      onPressed: () {},
                    ),
                    MenuItemButton(
                      trailingIcon: const Icon(Icons.send_outlined),
                      child: const Text("Forward"),
                      onPressed: () {},
                    ),
                    MenuItemButton(
                      trailingIcon: const Icon(Icons.copy_outlined),
                      child: const Text("Copy"),
                      onPressed: () {},
                    ),
                    MenuItemButton(
                      trailingIcon: const Icon(Icons.delete_outline),
                      child: const Text("Delete"),
                      onPressed: () {},
                    ),
                  ],
                  builder: (context, menuController, child) {
                    return GestureDetector(
                      onLongPress: () {
                        if (menuController.isOpen) {
                          menuController.close();
                        } else {
                          menuController.open();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(24),
                              bottomLeft: const Radius.circular(24),
                              topRight: isTopSame
                                  ? const Radius.circular(8)
                                  : const Radius.circular(24),
                              bottomRight: const Radius.circular(8),
                            ),
                            color: Theme.of(context).colorScheme.primary),
                        child: Text(
                          chatText.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        )
      ],
    );
  }
}

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({super.key, required this.reply});
  final String reply;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: Text(reply),
    );
  }
}
