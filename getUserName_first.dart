// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:thirteen_firestore_database/screens/login_screen.dart';
// import 'package:thirteen_firestore_database/screens/edit_profile_screen.dart';
// import 'package:thirteen_firestore_database/screens/profile_screen.dart';

// class GetUserName extends StatelessWidget {
//   final String? documentId;

//   const GetUserName({super.key, this.documentId});

//   @override
//   Widget build(BuildContext context) {
//     final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
//     final String docIdToFetch = documentId ?? uid;

//     CollectionReference usersMain =
//         FirebaseFirestore.instance.collection('Users');
//     CollectionReference usersAlt =
//         FirebaseFirestore.instance.collection('users');

//     return FutureBuilder<DocumentSnapshot>(
//       future: usersMain.doc(docIdToFetch).get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text("Something went wrong"));
//         }

//         if (snapshot.hasData && snapshot.data!.exists) {
//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           return _buildUserDetailScreen(context, data);
//         }

//         return FutureBuilder<DocumentSnapshot>(
//           future: usersAlt.doc(docIdToFetch).get(),
//           builder: (context, altSnapshot) {
//             if (altSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (altSnapshot.hasError) {
//               return const Center(child: Text("Something went wrong"));
//             }

//             if (!altSnapshot.hasData || !altSnapshot.data!.exists) {
//               return const Scaffold(
//                 body: Center(child: Text("User document not found.")),
//               );
//             }

//             final data = altSnapshot.data!.data() as Map<String, dynamic>;
//             return _buildUserDetailScreen(
//               context,
//               data,
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildUserDetailScreen(
//     BuildContext context,
//     Map<String, dynamic> data,
//   ) {
//     String userName =
//         '${data['first_name'] ?? data['name'] ?? ''} ${data['last_name'] ?? ''}';
//     String userEmail = data['email'] ?? 'No Email';
//     String? profileImageUrl =
//         data['profileImage']; // Make sure you store this in Firestore

//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: const Text("User Profile"),
//         backgroundColor: Colors.blue,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.deepPurple, Colors.deepPurpleAccent],
//                 ),
//               ),
//               accountName: Text(userName),
//               accountEmail: Text(userEmail),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: profileImageUrl != null
//                     ? NetworkImage(profileImageUrl)
//                     : null,
//                 child: profileImageUrl == null
//                     ? const Icon(Icons.person, size: 40)
//                     : null,
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('My Profile'),
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (_) => const ProfileScreen()));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Edit Profile'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => const EditProfileScreen()));
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("User Details",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 20),
//                     _readonlyField(
//                         "First Name", data['first_name'] ?? data['name'] ?? ''),
//                     const SizedBox(height: 15),
//                     _readonlyField("Last Name", data['last_name'] ?? ''),
//                     const SizedBox(height: 15),
//                     _readonlyField("Age", data['age']?.toString() ?? ''),
//                     const SizedBox(height: 15),
//                     _readonlyField("Phone Number",
//                         data['phone_number'] ?? data['contact'] ?? ''),
//                     const SizedBox(height: 15),
//                     _readonlyField("Address", data['address'] ?? ''),
//                     const SizedBox(height: 15),
//                     _readonlyField("Email", userEmail),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   FirebaseAuth.instance.signOut();
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                         builder: (context) => const LoginScreen()),
//                   );
//                 },
//                 child: const Text("Log Out"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _readonlyField(String label, String value) {
//     return TextFormField(
//       initialValue: value.isNotEmpty ? value : 'N/A',
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
