import 'package:bytclone/screens/profile.dart';
import 'package:bytclone/screens/signin.dart';
import 'package:bytclone/screens/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/videocard.dart';

class HomeScreen extends StatefulWidget {
  final Session session;

  HomeScreen({
    required this.session,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final SupabaseClient supabaseClient = Supabase.instance.client;
  var _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final stream = supabaseClient
        .from('video_metadata')
        .stream(primaryKey: ['id']);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF000B49),
            child: Stack(
              children: [
                // Centered Explore text
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Explore',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Buttons in top right corner
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen(session: widget.session,)),
                            );
                          },
                          icon: const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInScreen()), // Replace with your sign-in screen widget
                                  (route) => false, // This predicate ensures all routes are removed
                            );
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }else {
              final data = snapshot.data ?? [];
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final video = data[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: VideoCard(
                      thumbnailUrl: video['thumbnail_url'],
                      title: video['title'],
                      description: video['description'],
                      duration: video['length'],
                      url: video['url'],
                      dateUploaded: video['upload_date'],
                      onTap: () {
                        _navigateToVideoPlayer(video['url'], context);
                      },
                    ),
                  );
                  },
              );
            }
          },
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
void _navigateToVideoPlayer(String videoUrl, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
    ),
  );
}