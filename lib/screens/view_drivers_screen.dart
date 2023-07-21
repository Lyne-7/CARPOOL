// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class UserManagementPage extends StatefulWidget {
//   @override
//   _UserManagementPageState createState() => _UserManagementPageState();
// }
//
// class _UserManagementPageState extends State<UserManagementPage> {
//   final DatabaseReference _usersRef =
//   FirebaseDatabase.instance.reference().child('users');
//
//   // Function to update a user's name
//   Future<void> updateUser(String userId, String updatedName) async {
//     try {
//       await _usersRef.child(userId).update({'name': updatedName});
//       print('User updated successfully');
//     } catch (e) {
//       print('Failed to update user: $e');
//     }
//   }
//
//   // Function to delete a user
//   Future<void> deleteUser(String userId) async {
//     try {
//       await _usersRef.child(userId).remove();
//       print('User deleted successfully');
//     } catch (e) {
//       print('Failed to delete user: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Management'),
//       ),
//       body: StreamBuilder<Event>(
//         stream: _usersRef.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasError || !snapshot.hasData) {
//             return Text('Failed to fetch users');
//           }
//
//           final usersSnapshot = snapshot.data!.snapshot as DataSnapshot;
//           if (!usersSnapshot.exists) {
//             return Text('No users found');
//           }
//
//           final usersMap = usersSnapshot.value as Map<dynamic, dynamic>;
//
//           return ListView.builder(
//             itemCount: usersMap.length,
//             itemBuilder: (context, index) {
//               final userEntry = usersMap.entries.elementAt(index);
//               final userId = userEntry.key;
//               final userData = userEntry.value as Map<dynamic, dynamic>;
//               final userName = userData['name'] as String;
//
//               return ListTile(
//                 title: Text(userName),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             String updatedName = userName;
//                             return AlertDialog(
//                               title: Text('Update User'),
//                               content: TextFormField(
//                                 initialValue: userName,
//                                 onChanged: (value) {
//                                   updatedName = value;
//                                 },
//                               ),
//                               actions: [
//                                 ElevatedButton(
//                                   child: Text('Cancel'),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                                 ElevatedButton(
//                                   child: Text('Update'),
//                                   onPressed: () async {
//                                     await updateUser(userId, updatedName);
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: Text('Delete User'),
//                               content: Text('Are you sure you want to delete this user?'),
//                               actions: [
//                                 ElevatedButton(
//                                   child: Text('Cancel'),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                                 ElevatedButton(
//                                   child: Text('Delete'),
//                                   onPressed: () async {
//                                     await deleteUser(userId);
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
// }





import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewDriverScreen extends StatefulWidget {
  const ViewDriverScreen({Key? key}) : super(key: key);

  @override
  State<ViewDriverScreen> createState() => _ViewDriverScreenState();
}

class _ViewDriverScreenState extends State<ViewDriverScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Users'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addUser,
              child: const Text('Add User'),
            ),
             ElevatedButton(
               onPressed: getUsers,
              child: const Text('Get All Users'),
             ),
          ],
        ),
      ),
    );
  }

  void addUser() async {
    String name = '';
    String email = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty && email.isNotEmpty) {
                  DatabaseReference newUserRef = _databaseReference.child('users');
                  String newUserId = newUserRef.push().key!;
                  newUserRef.child(newUserId).set({
                    'name': name,
                    'email': email,
                  });
                  Fluttertoast.showToast(
                    msg: 'User added successfully',
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );


                  print('User added successfully');
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }




// FutureBuilder<DataSnapshot>(
  // future: FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid).get(),
  // builder: (context, snapShot) {
  // Map<Object?, Object?> data = snapShot.data!.value as Map<Object?, Object?>;
  // String email = data['email'].toString();
  // return Text('${email ?? "N/A"}',
  // style: TextStyle(
  // fontSize: 18,
  // fontWeight: FontWeight.bold,
  // ),
  // );
  // }
  // ),



  Future<void> updateUserInDatabase(String userId, String updatedName) async {
    try {
      DatabaseReference userRef = _databaseReference.child('users').child(userId);
      await userRef.update({'name': updatedName});
      print('User updated successfully');
    } catch (error) {
      print('Error updating user: $error');
      // Handle any error that occurred during the update operation
    }
  }

  void showUsersDialog(BuildContext context, List<Map<dynamic, dynamic>> users) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Users'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                String name = users[index]['name'];
                String email = users[index]['email'];

                return ListTile(
                  title: Text(name),
                  subtitle: Text(email),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteUser(String userId) async {
    final DatabaseReference _usersRef =
    FirebaseDatabase.instance.reference().child('users');

    try {
      await _usersRef.child(userId).remove();
      print('User deleted successfully');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  // void deleteUser(String userId) {
  //   DatabaseReference userRef = _databaseReference.child('users').child(userId);
  //   userRef.remove()
  //       .then((_) {
  //     print('User deleted successfully');
  //   })
  //       .catchError((error) {
  //     print('Failed to delete user: $error');
  //   });
  // }



  void getUsers() async {
    DatabaseReference usersRef = _databaseReference.child('users');
    DatabaseEvent event = await usersRef.once();
    DataSnapshot usersData = event.snapshot;

    if (!usersData.exists) {
      print('No users found');
      return;
    }

    List<Map<dynamic, dynamic>> users = [];
    if (usersData.value is Map<dynamic, dynamic>) {
      (usersData.value as Map<dynamic, dynamic>).forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          users.add(value);
        }
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Users'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user['id'];
              final userName = user['name'];

              return ListTile(
                title: Text(userName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String updatedName = '';

                            return AlertDialog(
                              title: Text('Edit User'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      updatedName = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Perform the update operation for the user using the userId and updatedName
                                    updateUserInDatabase(userId, updatedName);

                                    // Show a success message or perform any other necessary actions
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('User updated successfully'),
                                      ),
                                    );

                                    // Close the AlertDialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle edit operation for the user
                        // You can show a dialog or navigate to an edit screen
                        // using the user's ID (userId) or any other relevant data
                      },
                    ),










                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }













}
