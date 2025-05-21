import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:only_shef/pages/send_offer/screens/send_offer_screen.dart';
import 'package:only_shef/pages/send_offer/models/offer.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/pages/chat/services/chat_services.dart';
import 'package:only_shef/common/constants/show_snack_bar.dart';
import 'package:only_shef/common/constants/global_variable.dart';

import '../../cuisine/models/chef.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chef,
    required this.currentUserId,
    this.initialOffer,
  });
  final Chef chef;
  final String currentUserId;
  final Offer? initialOffer;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  bool isConnected = false;
  bool isOfferSent = false;
  bool isOfferCancelled = false;
  bool isLoading = false;
  final ChatServices _chatServices = ChatServices();

  @override
  void initState() {
    super.initState();
    print('Initial offer: ${widget.initialOffer?.toJson()}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSocket();
    });
    loadChatHistory();
    if (widget.initialOffer != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendOfferDetails(widget.initialOffer!);
      });
    }
  }

  void initSocket() {
    print('Initializing socket connection...');
    print('Current user ID: ${widget.currentUserId}');
    socket = IO.io(uri.replaceAll('/api', ''), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
    });

    socket.onConnect((_) {
      print('Socket connected successfully with ID: ${socket.id}');
      if (!mounted) {
        print('Widget not mounted, skipping setState');
        return;
      }
      try {
        setState(() {
          isConnected = true;
        });
        print('Emitting join event with userId: ${widget.currentUserId}');
        socket.emit('join', widget.currentUserId);
      } catch (e) {
        print('Error in onConnect: $e');
      }
    });

    socket.on('joined', (data) {
      print('Successfully joined chat: $data');
      if (!mounted) return;
      setState(() {
        isConnected = true;
      });
    });

    socket.onConnectError((data) {
      print('Socket connection error: $data');
      if (!mounted) {
        print('Widget not mounted, skipping error handling');
        return;
      }
      try {
        setState(() {
          isConnected = false;
        });
        showSnackBar(context, 'Connection error: $data');
      } catch (e) {
        print('Error showing connection error: $e');
      }
    });

    socket.onError((data) {
      print('Socket error: $data');
      if (!mounted) {
        print('Widget not mounted, skipping error handling');
        return;
      }
      try {
        setState(() {
          isConnected = false;
        });
        showSnackBar(context, 'Socket error: $data');
      } catch (e) {
        print('Error showing socket error: $e');
      }
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
      if (!mounted) {
        print('Widget not mounted, skipping disconnect handling');
        return;
      }
      try {
        setState(() {
          isConnected = false;
        });
      } catch (e) {
        print('Error handling disconnect: $e');
      }
    });

    socket.onReconnect((_) {
      print('Socket reconnected');
      if (!mounted) {
        print('Widget not mounted, skipping reconnection handling');
        return;
      }
      try {
        setState(() {
          isConnected = true;
        });
        print('Re-emitting join event with userId: ${widget.currentUserId}');
        socket.emit('join', widget.currentUserId);
      } catch (e) {
        print('Error in onReconnect: $e');
      }
    });

    socket.onReconnectAttempt((attemptNumber) {
      print('Socket reconnection attempt: $attemptNumber');
    });

    socket.onReconnectError((error) {
      print('Socket reconnection error: $error');
      if (!mounted) return;
      setState(() {
        isConnected = false;
      });
    });

    socket.onReconnectFailed((_) {
      print('Socket reconnection failed');
      if (!mounted) {
        print('Widget not mounted, skipping reconnection failure handling');
        return;
      }
      try {
        setState(() {
          isConnected = false;
        });
        showSnackBar(context, 'Failed to reconnect to chat server');
      } catch (e) {
        print('Error handling reconnection failure: $e');
      }
    });

    socket.on('message', (data) {
      print('Received message: $data');
      if (!mounted) {
        print('Widget not mounted, skipping message handling');
        return;
      }
      try {
        print('Adding message to list: ${data['message']}');
        setState(() {
          _messages.add({
            'message': data['message'],
            'isMe': data['senderId'] == widget.currentUserId,
            'isOffer': data['isOffer'] ?? false,
            'offerStatus': data['offerStatus'],
            'timestamp': data['timestamp'] != null
                ? DateTime.parse(data['timestamp'])
                : DateTime.now(),
          });
        });
        print(
            'Message added successfully. Total messages: ${_messages.length}');
      } catch (e) {
        print('Error handling message: $e');
      }
    });

    // Connect the socket
    print('Connecting socket...');
    socket.connect();
  }

  Future<void> loadChatHistory() async {
    try {
      final messages = await _chatServices.getChatHistory(
        context,
        widget.chef.id,
      );
      if (!mounted) return;
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      showSnackBar(context, 'Error loading chat history: $e');
    }
  }

  void _sendMessage() {
    print('Sending message: \\${_messageController.text}');
    print('Is connected: \\${isConnected}');
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      _messageController.clear();

      // Add message locally for instant feedback
      setState(() {
        _messages.insert(0, {
          'message': message,
          'isMe': true,
          'isOffer': false,
          'offerStatus': null,
          'timestamp': DateTime.now(),
        });
      });

      print('Emitting message to server...');
      socket.emit('message', {
        'senderId': widget.currentUserId,
        'receiverId': widget.chef.id,
        'message': message,
      });
    }
  }

  void _sendOfferDetails(Offer offer) {
    if (isConnected) {
      print('Sending offer details: ${offer.toJson()}');
      final offerMessage = '''
Offer Details:
Date: ${offer.date.toString().split(' ')[0]}
Time: ${offer.time}
Cuisine: ${offer.selectedCuisines.join(', ')}
Number of Persons: ${offer.numberOfPersons}
Total Amount: \$${(offer.selectedCuisines.length * offer.numberOfPersons * 50).toStringAsFixed(2)}
Additional Comments: ${offer.comments}
''';

      socket.emit('message', {
        'senderId': widget.currentUserId,
        'receiverId': widget.chef.id,
        'message': offerMessage,
        'isOffer': true,
        'offerStatus': 'sent',
      });
    }
  }

  void _cancelOffer() {
    if (isConnected && isOfferSent && !isOfferCancelled) {
      socket.emit('message', {
        'senderId': widget.currentUserId,
        'receiverId': widget.chef.id,
        'message': 'Offer has been cancelled',
        'isOffer': true,
        'offerStatus': 'cancelled',
      });
    }
  }

  @override
  void dispose() {
    print('Disposing chat screen');
    try {
      socket.disconnect();
      socket.dispose();
    } catch (e) {
      print('Error disposing socket: $e');
    }
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFDF7F2),
      appBar: AppBar(
        title: Text(
          widget.chef.username,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFFDF7F2),
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: isConnected ? Colors.green : Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/no_message.png', height: 100),
                              const SizedBox(height: 10),
                              Text(
                                'No Messages',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                _messages[_messages.length - 1 - index];
                            return message['isOffer'] == true
                                ? _buildOfferMessage(message)
                                : _buildTextMessage(message);
                          },
                        ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Type Message',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      icon: Icon(Icons.send, color: primaryColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: screen_height * 0.065,
                    child: ElevatedButton(
                      onPressed: isOfferSent
                          ? (isOfferCancelled ? null : _cancelOffer)
                          : () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendOfferScreen(
                                    chefId: widget.chef.id,
                                    selectedDate: DateTime.now(),
                                    chef: widget.chef,
                                  ),
                                ),
                              );
                              if (result != null && result is Offer) {
                                _sendOfferDetails(result);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOfferSent
                            ? (isOfferCancelled ? Colors.grey : Colors.red)
                            : Color(0xFF1E451B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isOfferSent
                            ? (isOfferCancelled
                                ? 'Offer Cancelled'
                                : 'Cancel Offer')
                            : 'Send Offer',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOfferMessage(Map<String, dynamic> message) {
    final lines = message['message'].split('\n');
    String date = '';
    String time = '';
    String cuisine = '';
    String budget = '';
    for (var line in lines) {
      if (line.trim().startsWith('Date:')) {
        date = line.replaceFirst('Date:', '').trim();
      } else if (line.trim().startsWith('Time:')) {
        time = line.replaceFirst('Time:', '').trim();
      } else if (line.trim().startsWith('Cuisine:')) {
        cuisine = line.replaceFirst('Cuisine:', '').trim();
      } else if (line.trim().startsWith('Total Amount:')) {
        budget = line.replaceFirst('Total Amount:', '').trim();
      }
    }

    return Align(
      alignment: message['isMe'] == true
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: secondryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offer Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  cuisine,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 18),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "At $time",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.person_2,
                        color: primaryColor,
                        size: 20,
                      ),
                      Text(
                        '${widget.initialOffer?.numberOfPersons} Person',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        budget,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (message['isMe'] == true &&
                    message['offerStatus'] != 'cancelled')
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextButton(
                      onPressed: _cancelOffer,
                      child: Text(
                        'Cancel Offer',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(Map<String, dynamic> message) {
    return Align(
      alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message['isMe'] ? Color(0xFF1E451B) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['message'],
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: message['isMe'] ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
