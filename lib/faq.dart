import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart'; // Import the AppDrawer class

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  late Future<List<DocumentSnapshot>> faqSnapshot;
  late List<DocumentSnapshot> allFAQs;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    faqSnapshot = _fetchFAQs();
  }

  Future<List<DocumentSnapshot>> _fetchFAQs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('FAQ').get();
    allFAQs = querySnapshot.docs;
    return allFAQs;
  }

  List<DocumentSnapshot> _filteredFAQs(String searchTerm) {
    if (searchTerm.isEmpty) {
      return allFAQs;
    } else {
      return allFAQs.where((faq) {
        var faqData = faq.data() as Map<String, dynamic>;
        String question = faqData['question'].toString().toLowerCase();
        return question.contains(searchTerm.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userUid = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      drawer: AppDrawer(userUid: userUid), // Pass userUid to AppDrawer
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: faqSnapshot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No FAQs found.'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {}); // Trigger a rebuild on every keystroke
                    },
                    decoration: InputDecoration(
                      labelText: 'Search FAQ',
                      hintText: 'Enter a question',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredFAQs(searchController.text).length,
                    itemBuilder: (context, index) {
                      var faqData = _filteredFAQs(searchController.text)[index]
                          .data() as Map<String, dynamic>;
                      String question = faqData['question'];
                      String answer = faqData['answer'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ExpansionTile(
                          title: Text(
                            question,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            SizedBox(height: 8),
                            Text(
                              answer,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
