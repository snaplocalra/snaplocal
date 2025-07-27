import 'package:flutter/material.dart';

class GroupChatScreen extends StatelessWidget {
  static const routeName = 'group-chat';

  final String groupName;
  final String groupType;
  final int memberCount;
  final String? groupImageUrl;

  const GroupChatScreen({
    Key? key,
    required this.groupName,
    required this.groupType,
    required this.memberCount,
    this.groupImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Group image
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(groupImageUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg'),
            ),
            const SizedBox(width: 12),
            // Group details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    groupType,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$memberCount Members',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Vertical dots icon
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        toolbarHeight: 70,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Group Members',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Chat messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
                  name: 'Kiran',
                  message: 'Hello, How are you Buddy',
                  isMention: false,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
                  name: 'Venaky',
                  message: '@Rupa please bring your charger today',
                  isMention: true,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
                  name: 'Pavan',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃', '😍'],
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
                  name: 'Rupa',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃'],
                  emojiCount: 2,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
                  name: 'Santhosh',
                  message: '@venky Hi, I am interested in this profile.',
                  isMention: true,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
                  name: 'Venaky',
                  message: 'Wow Great Idea 👏',
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
                  name: 'Pavan',
                  message: 'Hi, I am interested in this profile.',
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
                  name: 'Kiran',
                  message: 'Hello, How are you Buddy',
                  isMention: false,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
                  name: 'Venaky',
                  message: '@Rupa please bring your charger today',
                  isMention: true,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
                  name: 'Pavan',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃', '😍'],
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
                  name: 'Rupa',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃'],
                  emojiCount: 2,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
                  name: 'Santhosh',
                  message: '@venky Hi, I am interested in this profile.',
                  isMention: true,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
                  name: 'Kiran',
                  message: 'Hello, How are you Buddy',
                  isMention: false,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
                  name: 'Venaky',
                  message: '@Rupa please bring your charger today',
                  isMention: true,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/4.jpg',
                  name: 'Pavan',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃', '😍'],
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
                  name: 'Rupa',
                  message: 'Awsome it\'s nice',
                  emojis: ['😃'],
                  emojiCount: 2,
                ),
                _chatMessage(
                  avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
                  name: 'Santhosh',
                  message: '@venky Hi, I am interested in this profile.',
                  isMention: true,
                ),
              ],
            ),
          ),
          // Online members
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                ...List.generate(4, (index) => _onlineMember(index)),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '53\nmore',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message input bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.grey),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatMessage({
    required String avatar,
    required String name,
    required String message,
    bool isMention = false,
    List<String>? emojis,
    int? emojiCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      if (isMention)
                        TextSpan(
                          text: message.split(' ')[0] + ' ',
                          style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                        ),
                      TextSpan(
                        text: isMention ? message.substring(message.indexOf(' ') + 1) : message,
                        style: const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (emojis != null && emojis.isNotEmpty)
                  Row(
                    children: [
                      ...emojis.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Text(e, style: const TextStyle(fontSize: 16)),
                          )),
                      if (emojiCount != null)
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            emojiCount.toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _onlineMember(int index) {
    final avatars = [
      'https://randomuser.me/api/portraits/women/2.jpg',
      'https://randomuser.me/api/portraits/men/6.jpg',
      'https://randomuser.me/api/portraits/women/3.jpg',
      'https://randomuser.me/api/portraits/men/7.jpg',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatars[index]),
            radius: 24,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 