import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {  
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String UsersToDo;

  List list = [];

    void initFirebase() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyClce28c1lrgHBzHhmZV2z8kWZzaiFtgdo",
        appId: "1:128806163593:android:94f152b5b2dc07584ce258",
        messagingSenderId: "",
        projectId: "todo-97ed2"),
  );
  }

  @override
  void initState() {
    super.initState();
    initFirebase();


    list.addAll(['Buy milk', 'Wish dishes', 'Do Homework', ]);
  }
  
  


  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(title: Text('Menu'),),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton.icon(onPressed: (){
                    Navigator.popAndPushNamed(context, '/');
                  }, label: Text('First page'), icon: Icon(Icons.home),),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  ElevatedButton.icon(onPressed: (){}, label: Text('About us'), icon: Icon(Icons.person_2),),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(title: 
        Text('To do List', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 30),), backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(onPressed: _menuOpen, 
          icon: Icon(Icons.menu))
        ],
      ),
      body: StreamBuilder(
  stream: FirebaseFirestore.instance.collection('items').snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return Center(child: Text('No list please add it'));
    }

    var documents = snapshot.data!.docs;
    return ListView.builder(
      padding: EdgeInsets.only(top: 30),
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(documents[index].id),
          child: Card(
            child: ListTile(
              title: Text(documents[index].get('item')),
              trailing: IconButton(
                onPressed: () {
                  String docId = documents[index].id;
                  FirebaseFirestore.instance.collection('items').doc(docId).delete();
                  
                },
                icon: Icon(Icons.delete_forever, color: Colors.red, size: 30),
              ),
            ),
          ),
          onDismissed: (direction) {
            String docId = documents[index].id;
            FirebaseFirestore.instance.collection('items').doc(docId).delete();
            }
        );
      },
    );
  },
),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text('Add task'),
              content: TextField(
                onChanged: (String value) {
                  UsersToDo = value;
                },
              ),
              actions: [
                ElevatedButton(onPressed: () {

                  FirebaseFirestore.instance.collection('items').add({'item': UsersToDo});

                  Navigator.of(context).pop();
                }, 
                child: Icon(Icons.add_business))
              ],
            );
          });
        }, 
        child: Icon(Icons.add_box, color: Color.fromARGB(255, 255, 255, 255),),
    ));
  }
}