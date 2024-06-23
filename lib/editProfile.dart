import 'package:flutter/material.dart';
import 'drawer.dart';
import 'UserUidSingleton.dart'; // Import the UserUidSingleton class
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? password;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _icNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? userUid = UserUidSingleton().userUid;
    print('User UID: $userUid');

      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userUid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          var data = userDoc.data()!;
          setState(() {
            _firstNameController.text = data['first_name'] as String? ?? '';
            _lastNameController.text = data['last_name'] as String? ?? '';
            _icNumberController.text = data['ic_number'] as String? ?? '';
            password = data['password'] as String?;
            _phoneNumberController.text = data['phone_number'] as String? ?? '';
            _emailController.text = data['e_mail'] as String? ?? '';
          });
        } else {
          print('User document not found or missing fields');
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
  }

  void _changePassword() async {
    String currentPassword = _passwordController.text.trim();
    if (currentPassword == password) {
      // Allow user to change password
      setState(() {
        password = _newPasswordController.text.trim();
      });
      // Save the new password to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(UserUidSingleton().userUid)
            .update({'password': password});
        print('Password updated successfully');
      } catch (e) {
        print('Error updating password: $e');
      }
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Incorrect current password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(UserUidSingleton().userUid).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone_number': _phoneNumberController.text,
        'e_mail': _emailController.text,
      });
      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  void _confirmChanges() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
                setState(() {
                  _isEditing = false;
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Profile Page',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _icNumberController,
                decoration: InputDecoration(
                  labelText: 'IC Number',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                readOnly: true,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                readOnly: !_isEditing,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                readOnly: !_isEditing,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: _phoneNumberController.text.isEmpty ? 'Optional' : '',
                ),
                readOnly: !_isEditing,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: _emailController.text.isEmpty ? 'Optional' : '',
                ),
                readOnly: !_isEditing,
              ),
              TextFormField(
                initialValue: '*',
                decoration: const InputDecoration(labelText: 'Password'),
                readOnly: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Change Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Enter Current Password',
                              ),
                              obscureText: true,
                            ),
                            TextField(
                              controller: _newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Enter New Password',
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _changePassword();
                            },
                            child: const Text('Change'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isEditing
                    ? _confirmChanges
                    : () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                child: Text(_isEditing ? 'Save' : 'Edit'),
              ),
            ],
          ),
        ),
    ),
   );
  }
}