import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Avatar extends StatelessWidget{

  final String? avatarUrl;
  final void Function(String) onUpload;

  const Avatar({
    super.key,
    required this.avatarUrl,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Container(width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.black, // Adjust color as needed
              width: 2, // Adjust border width as needed
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:avatarUrl != null
                ? Image.network(
              avatarUrl!,
              fit: BoxFit.cover, // Adjust the fit as needed
            )
                : Container(
              child: const Center(
                child: Text('No Image'),
              ),
            )
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              width: 35,
              height: 35,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF000B49),
              ),
              child: IconButton(
                onPressed: () async {
                  //updating profile photo
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if(image==null) {
                    return;
                  }
                  final imageBytes = await image.readAsBytes();
                  final userId = Supabase.instance.client.auth.currentUser!.id;
                  final imagePath = '/$userId/profile';
                  final response = await Supabase.instance.client.storage
                      .from('avatars')
                      .list(path: userId);
                  bool imageExists = response.isNotEmpty;
                  if(imageExists){
                    await Supabase.instance.client.storage
                        .from('avatars')
                        .updateBinary(imagePath, imageBytes);
                  }
                  else{
                    await Supabase.instance.client.storage.from('avatars')
                        .uploadBinary(imagePath, imageBytes);
                  }
                  String imageUrl =  Supabase.instance.client.storage.from('avatars').getPublicUrl(imagePath);
                  imageUrl = Uri.parse(imageUrl)
                      .replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()})
                      .toString();
                  onUpload(imageUrl);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),)

          ),
        )

      ],
    );
  }
}