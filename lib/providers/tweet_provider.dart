import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/providers/user_provider.dart';

final TweetProvider = Provider<TwitterApi>((ref) {
  return TwitterApi(ref);
});

final feedProvider = StreamProvider.autoDispose<List<Tweet>>((ref) {
  return FirebaseFirestore.instance
      .collection('tweets')
      .orderBy('postTime', descending: true)
      .snapshots()
      .map((event) {
    List<Tweet> tweets = [];
    for (int i = 0; i < event.docs.length; i++) {
      tweets.add(Tweet.fromMap(event.docs[i].data()));
    }
    return tweets;
  });
});

class TwitterApi {
  TwitterApi(this.ref);
  final Ref ref;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postTweet(String tweet) async {
    LocalUser currentUser = ref.read(userProvider);
    await _firestore.collection('tweets').add(Tweet(
            uid: currentUser.id,
            profilePic: currentUser.user.profilepic,
            name: currentUser.user.name,
            tweet: tweet,
            postTime: Timestamp.now())
        .toMap());
  }
}
