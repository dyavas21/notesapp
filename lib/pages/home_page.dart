import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/pages/login_page.dart';
import 'package:notesapp/widgets/card_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class IdGenerator {
  int _counter = 0;

  int getNextId() {
    _counter++;
    return _counter;
  }
}

int currentColorIndex = 0;
int currentId = 1;

class _HomePageState extends State<HomePage> {
  SharedPreferences? prefs;
  List<Color> fixedColors = [
    Color(0xff466060),
    Color(0xff57A773),
    Color(0xff7B435B),
    Color(0xff648DE5),
    Color(0xff304C89),
  ];

  IdGenerator idGenerator = IdGenerator();

  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  String? firstName = '';
  String? lastName = '';

  String idTerbaru = '';

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  String query = '';

  final TextEditingController _descController = TextEditingController();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final user = FirebaseAuth.instance.currentUser;

  void onButtonPressed() {
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid != null) {
      DocumentReference userDocumentRef =
          FirebaseFirestore.instance.collection('users').doc(userUid);

      print(userDocumentRef);
    }
  }

  // User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentColorIndex = prefs.getInt('currentColorIndex') ?? 0;
      currentId = prefs.getInt('currentId') ?? 1;
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentColorIndex', currentColorIndex);
    prefs.setInt('currentId', currentId);
  }

  Future<Map<String, String>> getName(String userUid) async {
    final userDocumentRef =
        FirebaseFirestore.instance.collection('users').doc(userUid);

    try {
      final userDocument = await userDocumentRef.get();
      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        final firstName = userData['first name'] ?? '';
        final lastName = userData['last name'] ?? '';

        print(firstName);
        print(lastName);

        return {
          'firstName': firstName,
          'lastName': lastName,
        };
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final userNotesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notes');
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Enter your title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Enter your description',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  final String title = _titleController.text;
                  final String desc = _descController.text;

                  if (title.isEmpty || desc.isEmpty) {
                    return _error();
                  } else {
                    await userNotesCollection.add({
                      "id": currentId,
                      "title": title,
                      "desc": desc,
                      "colorIndex": currentColorIndex,
                      "timestamp": FieldValue.serverTimestamp(),
                    }).then((DocumentReference doc) {
                      idTerbaru = doc.id;
                    });
                    ;
                    setState(() {
                      currentId++;
                      currentColorIndex =
                          (currentColorIndex + 1) % fixedColors.length;
                    });
                    _titleController.text = '';
                    _descController.text = '';
                    _saveData();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _titleController.text = '';
      _descController.text = '';
    });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final userNotesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notes');
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _descController.text = documentSnapshot['desc'];
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Enter your title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Enter your description',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () async {
                  final String title = _titleController.text;
                  final String desc = _descController.text;
                  await userNotesCollection
                      .doc(documentSnapshot!.id)
                      .update({"title": title, "desc": desc});
                  _titleController.text = '';
                  _descController.text = '';
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _error() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Title atau description tidak boleh kosong'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _delete(String productId) async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final userNotesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notes');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Apakah anda yakin ingin menghapus note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                userNotesCollection.doc(productId).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have successfully deleted a product'),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _open(DocumentSnapshot? documentSnapshot) async {
    Timestamp? timestamp = documentSnapshot?['timestamp'];
    DateTime dateTime = timestamp != null ? timestamp.toDate() : DateTime.now();
    String formattedDate = DateFormat('d MMMM y').format(dateTime);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: fixedColors[documentSnapshot?['colorIndex']],
          elevation: 1,
          title: Text(
            documentSnapshot?['title'],
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          content: Text(
            formattedDate + '\n\n' + documentSnapshot?['desc'],
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tutup',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    _searchController.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _focusScopeNode.unfocus();
        },
        child: SafeArea(
          child: FocusScope(
            node: _focusScopeNode,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      Text(
                        'Notes',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false,
                              );
                            }).catchError((error) {
                              print("Error during logout: $error");
                            });
                          },
                          child: Icon(Icons.exit_to_app))
                    ],
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   width: MediaQuery.of(context).size.width - 48,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //       color: Colors.grey,
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: TextField(
                //           controller: _searchController,
                //           onChanged: (value) {
                //             setState(() {
                //               query = value;
                //             });
                //           },
                //           decoration: InputDecoration(
                //             border: InputBorder.none,
                //             hintText: 'Search by title...',
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //           onTap: () {
                //             _focusScopeNode.unfocus();
                //             // print(query);
                //             print(userUid);
                //           },
                //           child: Icon(Icons.search))
                //     ],
                //   ),
                // ),
                Expanded(
                  child: StreamBuilder(
                    stream: query.isEmpty
                        ? user != null
                            ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid)
                                .collection('notes')
                                .orderBy('id', descending: false)
                                .snapshots()
                            : const Stream<QuerySnapshot>.empty()
                        : user != null
                            ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid)
                                .collection('notes')
                                .where('title', isEqualTo: query)
                                .snapshots()
                            : const Stream<QuerySnapshot>.empty(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return CardContainer(
                              key: Key(index.toString()),
                              title: documentSnapshot['title'],
                              desc: documentSnapshot['desc'],
                              colorBox:
                                  fixedColors[documentSnapshot['colorIndex']],
                              onView: () => {
                                _open(documentSnapshot),
                              },
                              onEdit: () => _update(documentSnapshot),
                              onDelete: () {
                                _delete(documentSnapshot.id);
                              },
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: 20,
          bottom: 20,
        ),
        child: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
