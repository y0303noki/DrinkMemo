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

  Future<String?> myCoffeeDialog(
    BuildContext context,
    bool isUpdate,
    String name,
    String brandName,
    String shopName,
  ) async {
    var result = showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('このコーヒーをマイコーヒーに登録しますか？'),
          content: !isUpdate
              ? Text('よく飲むコーヒーをマイコーヒーにすることで次から簡単に登録できます')
              : Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // columnの高さを自動調整
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('登録中のマイコーヒー'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      brandName != ''
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    brandName,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      shopName != ''
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    shopName,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
          // content: Text("This is the content"),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.pop(context, 'NO'),
            ),
            TextButton(
              child: const Text('登録する'),
              onPressed: () => Navigator.pop(context, 'YES'),
            ),
          ],
        );
      },
    );
    return result;
  }
}
