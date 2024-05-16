

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/providers/tweet_provider.dart';

class createTweet extends ConsumerWidget {
  const createTweet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tweet = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Tweet"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(133, 0, 0, 0),
                  ),
                ),

                // This is the normal border
              ),
              controller: tweet,
              maxLines: 4,
              maxLength: 280,
            ),
            TextButton(
                onPressed: () {
                  ref.read(TweetProvider).postTweet(tweet.text);
                  Navigator.pop(context);
                },
                child: const Text("Post a Tweet"))
          ],
        ),
      ),
    );
  }
}
