import 'package:flutter/material.dart';

class CustomDialog {
  void openSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('アイコンの説明'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min, // columnの高さを自動調整
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 3,
                        height: 25,
                        color: Colors.red,
                      ),
                      const Text(
                        'おうち',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        width: 3,
                        height: 25,
                        color: Colors.blue,
                      ),
                      const Text(
                        'おみせ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: const Icon(Icons.favorite_outline_outlined),
                      ),
                      const Text(
                        'お気に入り',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // content: Text("This is the content"),
          actions: [
            TextButton(
              child: const Text('閉じる'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
