import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/Components/Utils/classes.dart';
import 'package:redesigned/Components/Utils/data.dart';
import 'package:redesigned/Components/Utils/open_container.dart';
import 'package:redesigned/chat_screen.dart';
import 'package:redesigned/screens/messages/messages_view_model.dart';
import 'package:redesigned/search_message_screen.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth > 840
          ? const MessageScreenDesktop()
          : const MessageScreenMobile(),
    );
  }
}

class MessageScreenMobile extends StatelessWidget {
  const MessageScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "Messages",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          const MessageSearchAnchor(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.black,
              child: CachedNetworkImage(
                height: 40,
                width: 40,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholderFadeInDuration: const Duration(seconds: 0),
                placeholder: (context, url) => Icon(
                  Icons.account_circle_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                fit: BoxFit.contain,
                imageUrl: linkToPfp,
              ),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 8),
                ...filters.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        side: BorderSide.none,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        label: Text(e),
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        selected: viewModel.currentFilters.contains(e),
                        onSelected: (bool isSelected) {
                          viewModel.toggleFilter(e, isSelected);
                        },
                      ),
                    ))
              ],
            ),
          ),
          ...viewModel.chatData.map((e) => OpenContainer(
                useRootNavigator: true,
                tappable: false,
                transitionType: ContainerTransitionType.fade,
                transitionDuration: Durations.medium3,
                reverseTransitionDuration: Durations.short4,
                middleColor: Theme.of(context).colorScheme.surface,
                closedColor: Theme.of(context).colorScheme.surface,
                openColor: Theme.of(context).colorScheme.surface,
                openElevation: 0,
                closedElevation: 0,
                clipBehavior: Clip.none,
                closedBuilder: (context, close) => ChatWidget(
                  chat: e,
                  openChat: () {
                    close();
                  },
                ),
                openBuilder: (context, _) => MobileChatScreen(
                  person: e.person,
                ),
              )),
          const SizedBox(height: 120)
        ],
      ),
    );
  }
}

class MessageScreenDesktop extends StatelessWidget {
  const MessageScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14)),
              width: MediaQuery.sizeOf(context).width / 3.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SearchBar(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainerHigh),
                      leading: const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(Symbols.search),
                      ),
                      hintText: "Search messages",
                      onTap: () {},
                      elevation: const WidgetStatePropertyAll(0),
                      trailing: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  placeholderFadeInDuration:
                                      const Duration(seconds: 0),
                                  placeholder: (context, url) => Icon(
                                      Icons.account_circle_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  fit: BoxFit.contain,
                                  imageUrl: linkToPfp),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                      )))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 8),
                        ...filters.map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                side: BorderSide(
                                    color: viewModel.currentFilters.contains(e)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .outlineVariant),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                label: Text(e),
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                selected: viewModel.currentFilters.contains(e),
                                onSelected: (bool isSelected) {
                                  viewModel.toggleFilter(e, isSelected);
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    children: chats
                        .map((e) => ChatWidgetDesktop(
                            chat: e,
                            onPressed: () {
                              viewModel.selectActiveChat(e.person);
                            }))
                        .toList(),
                  ))
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: viewModel.currentActive != null
                  ? DesktopChatScreen(person: viewModel.currentActive!)
                  : Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface),
                      padding: const EdgeInsets.symmetric(),
                      child: const Center(
                        child: Text("Messages"),
                      ),
                    ),
            )),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ChatWidgetDesktop extends StatelessWidget {
  const ChatWidgetDesktop(
      {super.key, required this.chat, required this.onPressed});
  final Chat chat;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        onTap: onPressed,
        title: Text(
          chat.person.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: CircleAvatar(
          radius: 28,
          child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
              placeholder: (context, url) => Icon(Icons.account_circle_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              fit: BoxFit.contain,
              imageUrl: chat.person.pfpPath),
        ),
        subtitle: Text(
          maxLines: 1,
          chat.lastMessageState == LastMessageState.sentByUserAndSeen
              ? "Seen"
              : chat.lastMessageState == LastMessageState.sentByUserAndUnseen
                  ? "Sent"
                  : chat.newMessage > 1
                      ? "${chat.newMessage} new messages"
                      : chat.lastMessage,
          style: TextStyle(
              fontSize: 14,
              fontWeight:
                  chat.newMessage == 0 ? FontWeight.w500 : FontWeight.w700,
              letterSpacing: 0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chat.lastTime,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

Set<String> filters = {'Unread', 'Read', 'Groups', 'Active', 'Starred'};

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chat, required this.openChat});
  final VoidCallback openChat;
  final Chat chat;

  Widget _chatBottomSheet(BuildContext context) => ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.attach_file_outlined),
            title: const Text("Send Attachment"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.archive_outlined),
            title: const Text("Archive"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.message_outlined),
            title: const Text("Mute Messages"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Symbols.delete_outline),
            title: const Text("Delete"),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openChat,
      child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: CircleAvatar(
                  radius: 24,
                  child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholderFadeInDuration: const Duration(seconds: 0),
                      placeholder: (context, url) => Icon(
                          Icons.account_circle_rounded,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      fit: BoxFit.contain,
                      imageUrl: chat.person.pfpPath),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    chat.person.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    chat.lastMessageState == LastMessageState.sentByUserAndSeen
                        ? "Seen"
                        : chat.lastMessageState ==
                                LastMessageState.sentByUserAndUnseen
                            ? "Sent"
                            : chat.newMessage > 1
                                ? "${chat.newMessage} new messages"
                                : chat.lastMessage,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: chat.newMessage == 0
                            ? FontWeight.w500
                            : FontWeight.w700,
                        letterSpacing: 0),
                  ),
                ],
              )),
              const SizedBox(width: 18),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Text(
                    chat.lastTime,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useRootNavigator: true,
                          showDragHandle: true,
                          isDismissible: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) => _chatBottomSheet(context));
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              )
            ],
          )),
    );
  }
}

class MessageSearchAnchor extends StatelessWidget {
  const MessageSearchAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        middleColor: Theme.of(context).colorScheme.surface,
        closedShape: const CircleBorder(),
        closedColor: Colors.transparent,
        openElevation: 0,
        closedElevation: 0,
        closedBuilder: (context, openContainer) => SizedBox(
              height: 45,
              width: 45,
              child: IconButton(
                  onPressed: openContainer,
                  icon: const Icon(
                    Icons.search,
                    weight: 600,
                  )),
            ),
        openBuilder: (context, controller) => const SearchMessageScreen());
  }
}
