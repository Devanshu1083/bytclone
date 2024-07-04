import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final String label;
  final IconData icon;
  final Function(String) onUpdate; // Callback function to update text

  TextWidget({required this.text,required this.label,required this.icon, required this.onUpdate});

  bool validatePhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(r'^(\+91[\-\s]?)?[0]?[789]\d{9}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  void showEditDialog(BuildContext context) {
    String newText = text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextFormField(
          initialValue: text,
          onChanged: (value) {
            newText = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (label!='phonenumber' || validatePhoneNumber(newText)) {
                try{
                  String field = label;
                  if(label=='name'){
                    field ='username';
                  }else if(label=='phone'){
                    field = 'phonenumber';
                  }
                  await Supabase.instance.client
                      .from('profiles')
                      .update({'${field}': newText})
                      .eq('id', Supabase.instance.client.auth.currentUser!.id);
                  onUpdate(newText);
                  Navigator.of(context).pop();
                } catch (error){
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to update ${label}'),
                  ));
                }
              } else {
                // Show validation error message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Invalid phone number'),
                ));
              }
              //Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF000B49)),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: label=='email'
          ? EdgeInsets.all(13)
          : EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: [
          Icon(icon), // Info icon
          Expanded(
            child: text==''? Text('   add ${label}',style: TextStyle(color: Colors.grey[400]),):Text('   ${text}',
              maxLines: label == 'about' ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ), // Display text from Supabase
          ),
          label=='email'
              ? Container()
              :IconButton(
            icon: Icon(Icons.edit,size: 16,),
            onPressed: () {
              showEditDialog(context); // Open edit dialog
            },
          ),
        ],
      ),
    );
  }
}