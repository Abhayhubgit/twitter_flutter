// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/pages/create.dart';
import 'package:twitter/pages/setting.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser curUser = ref.watch(userProvider);
    return Scaffold( 
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 1,
            ),
          ),
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(curUser.user.profilepic),
                ),
              ),
            );
          }),
          title: const Image(
            image: AssetImage('assets/logo.png'),
            width: 50,
          ),
        ),
        body: ref.watch(feedProvider).when(
            data: (List<Tweet> tweets) {
              return ListView.separated(            
                  separatorBuilder: (context, index) => Divider(
                        color: const Color.fromARGB(135, 0, 0, 0),
                        
                      ),
                  itemCount: tweets.length,
                  itemBuilder: (context, count) {
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(tweets[count].profilePic),
                      ),
                      title: Text(
                        tweets[count].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        tweets[count].tweet,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  });
                  
            },
            error: (error, stackTrace) => Center(child: Text("error")),
            loading: () {
              return CircularProgressIndicator();
            }),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                curUser.user.profilepic,
                height: 300,
               
                fit: BoxFit.fill,
              ),
              ListTile(
                title: Text(
                  "Hello ${curUser.user.name} ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              ListTile(
                title: Text("Sign Out"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  ref.read(userProvider.notifier).logOut();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => createTweet()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
