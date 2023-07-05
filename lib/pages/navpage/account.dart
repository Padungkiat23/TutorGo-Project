import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorgo/auth.dart';
import 'package:tutorgo/pages/navpage/update_profile.dart';
import 'package:tutorgo/pages/widget/header_widget.dart';
import 'package:flutter/services.dart';
import 'package:tutorgo/pages/login.dart';
import 'package:tutorgo/pages/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userHeadinfo() {
    if (user == null) {
      // User is not authenticated
      return Text('User not authenticated');
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data available');
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          String fname = userData['firstname'] ?? 'User firstname';
          String lname = userData['lastname'] ?? 'User lastname';
          String role = userData['role'] ?? 'User role';
          String imageName = userData['profilePicture'] ?? 'User Image';

          return Column(
            children: [
              FutureBuilder<String>(
                future: _getImageUrl(imageName),
                builder: (context, imageNameSnapshot) {
                  if (imageNameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // if (imageUrlSnapshot.hasError) {
                  //   return Text('Error: ${imageUrlSnapshot.error}');
                  // }

                  // String imageUrl = imageUrlSnapshot.data ?? '';

                  if (imageName.isNotEmpty) {
                    return ClipOval(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          imageName,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return ClipOval(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/profile-icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              Text(
                '$fname $lname',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  Future<String> _getImageUrl(String imageName) async {
    // Refresh user token
    final idTokenResult = await user?.getIdTokenResult();
    final token = idTokenResult?.token;

    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pictures/$imageName');
    final url = await ref.getDownloadURL();

    return url;
  }

  Widget _userInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data available');
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        String email = userData['email'] ?? 'User email';
        String fname = userData['firstname'] ?? 'User firstname';
        String lname = userData['lastname'] ?? 'User lastname';
        String phone = userData['mobile'] ?? 'User mobile';
        String role = userData['role'] ?? 'User role';

        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.mail),
              title: Text("email"),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.text_format),
              title: Text("Name"),
              subtitle: Text(fname + ' ' + lname),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Phone"),
              subtitle: Text(phone),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Role"),
              subtitle: Text(role),
            ),
          ],
        );
      },
    );
  }

  Widget _title() {
    return const Text('Account page');
  }

  Widget _userUid() {
    return Text(
      user?.email ?? 'User email',
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

  Widget _signOutButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: signOut,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            side: BorderSide.none,
            shape: const StadiumBorder()),
        child: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).hintColor,
              ])),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _userHeadinfo(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        _userInfo(),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => updateProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  _signOutButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
