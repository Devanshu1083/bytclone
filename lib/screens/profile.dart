
import 'package:bytclone/components/avatar.dart';
import 'package:bytclone/components/textwidget.dart';
import 'package:bytclone/screens/signin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class ProfileScreen extends StatefulWidget {
  final Session session;
  ProfileScreen({required this.session});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? avatarUrl;
  String? name;
  String? email;
  String? number;
  String? about;
  var _loading = true;

  //getting the user profile data
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentSession!.user.id;
      final data = await Supabase.instance.client.from('profiles').select().eq('id', userId).single();
      name = (data['username'] ?? '') as String;
      email = (data['email'] ?? '') as String;
      number = (data['phonenumber'] ?? '') as String;
      avatarUrl = (data['avatar_url'] ?? '') as String;
      about = (data['about'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red)
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unexpected error occurred'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Example navigation action
          },
        ),
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
                    'PROFILE',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Avatar(avatarUrl: avatarUrl, onUpload: (imageUrl) async {
                await Supabase.instance.client.from('profiles').update({
                  'avatar_url':imageUrl
                }).eq('id', Supabase.instance.client.auth.currentUser!.id);
                setState(() {
                  avatarUrl = imageUrl;
                });
              }),
              const SizedBox(height: 5,),
              Text(
                'Click icon to edit your avatar.',
                style: TextStyle(fontSize: 12,color: Colors.grey[600]),
              ),
              const SizedBox(height: 80,),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.9,
                    child: Column(
                      children: [
                        TextWidget(text: email ??'', label: 'email', icon: Icons.email, onUpdate: (newEmail){
                          setState(() {
                            email = newEmail;
                          });
                        }),
                        const SizedBox(height: 20,),
                        TextWidget(text: name ??'', label: 'name', icon: Icons.person, onUpdate: (newName){
                          setState(() {
                            name = newName;
                          });
                        }),
                        const SizedBox(height: 20,),

                        TextWidget(text: about ??'', label: 'about', icon: Icons.info_outline, onUpdate: (newAbout){
                          setState(() {
                            about = newAbout;
                          });
                        }),
                        const SizedBox(height: 20,),

                        TextWidget(text: number ??'', label: 'phone', icon: Icons.phone, onUpdate: (newNumber){
                          setState(() {
                            number = newNumber;
                          });
                        }),

                      ],
                    )
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height+20;
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
