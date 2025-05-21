import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:only_shef/common/constants/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:only_shef/provider/user_provider.dart';

class ChatServices {
  Future<List<Map<String, dynamic>>> getChatHistory(
    BuildContext context,
    String otherUserId,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final response = await http.get(
        Uri.parse('$uri/chat/history/${user.id}/$otherUserId'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((msg) => {
                  'message': msg['message'],
                  'isMe': msg['senderId'] == user.id,
                  'isOffer': msg['isOffer'] ?? false,
                  'offerStatus': msg['offerStatus'],
                  'timestamp': DateTime.parse(msg['timestamp']),
                })
            .toList();
      } else {
        throw Exception('Failed to load chat history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversations(
    BuildContext context,
  ) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final response = await http.get(
        Uri.parse('$uri/chat/conversations/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((conv) => {
                  'userId': conv['_id'],
                  'lastMessage': {
                    'message': conv['lastMessage']['message'],
                    'isMe': conv['lastMessage']['senderId'] == user.id,
                    'isOffer': conv['lastMessage']['isOffer'] ?? false,
                    'offerStatus': conv['lastMessage']['offerStatus'],
                    'timestamp':
                        DateTime.parse(conv['lastMessage']['timestamp']),
                  },
                })
            .toList();
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
