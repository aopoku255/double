import 'package:doubles/src/model/questions.dart';
import 'package:doubles/src/service/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  bool _isPublic = false; // default send mode

  final TextEditingController _controller = TextEditingController();
  final PersonalQuestionService _service = PersonalQuestionService();
  final List<PersonalQuestion> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  int? _currentUserId; // keep logged-in user ID

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = pref.getInt("userId");
    });
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    if (_currentUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final userQuestions =
      await _service.fetchQuestions(userId: _currentUserId!);
      final publicQuestions = await _service.fetchPublicQuestions();

      // remove current user's public questions to avoid duplicates
      publicQuestions.removeWhere((q) => q.userId == _currentUserId);

      userQuestions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      publicQuestions.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      setState(() {
        _messages.clear();
        _messages.addAll(userQuestions);
        _messages.addAll(publicQuestions);
      });

      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load messages")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _currentUserId == null) return;

    final now = DateTime.now();

    setState(() {
      _messages.add(
        PersonalQuestion(
          id: 0, // temporary id
          userId: _currentUserId!,
          question: text,
          isUser: true,
          createdAt: now,
          updatedAt: now,
          isPublic: _isPublic,
        ),
      );
      _controller.clear();
    });

    _scrollToBottom();

    try {
      await _service.createQuestion(
        userId: _currentUserId!,
        question: text,
        isPublic: _isPublic,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send message")),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getMessageGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) {
      return "Today";
    } else if (msgDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat("MMM d, yyyy").format(date);
    }
  }

  Widget _buildMessage(PersonalQuestion message) {
    final isFromCurrentUser = message.userId == _currentUserId;
    String formattedTime = DateFormat('hh:mm a').format(message.createdAt);
    String visibility = message.isPublic ? "Public" : "Private";

    return Align(
      alignment:
      isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isFromCurrentUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.question,
              style: TextStyle(
                color: isFromCurrentUser ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 10,
                    color: isFromCurrentUser ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  visibility,
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: message.isPublic
                        ? Colors.green
                        : (isFromCurrentUser
                        ? Colors.white70
                        : Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<PersonalQuestion> filteredMessages) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredMessages.length,
      itemBuilder: (context, index) {
        final message = filteredMessages[index];
        final currentDateLabel =
        _getMessageGroupLabel(message.createdAt);

        bool showHeader = false;
        if (index == 0) {
          showHeader = true;
        } else {
          final previousMessage = filteredMessages[index - 1];
          final previousDateLabel =
          _getMessageGroupLabel(previousMessage.createdAt);
          if (currentDateLabel != previousDateLabel) {
            showHeader = true;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  currentDateLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            _buildMessage(message),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final privateMessages = _messages.where((msg) => !msg.isPublic).toList();
    final publicMessages = _messages.where((msg) => msg.isPublic).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Ask a Question"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Private"),
              Tab(text: "Public"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildMessageList(privateMessages),
                  _buildMessageList(publicMessages),
                ],
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onTap: _scrollToBottom,
                        decoration: InputDecoration(
                          hintText: "Type your question...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          suffixIcon: DropdownButtonHideUnderline(
                            child: DropdownButton<bool>(
                              value: _isPublic,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: const [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text("Public"),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text("Private"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _isPublic = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon:
                      const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
