import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_app_local/todo.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todo1');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String todoitem = "";
  final text = TextEditingController();

  @override
  void dispose() {
    Hive.close();
    Hive.box('todo1').compact();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(hintText: 'Enter todo here'),
                controller: text,
                onChanged: (value) {},
              ),
            )),
            OutlineButton(
              onPressed: () {
                var t = Hive.box<Todo>('todo1');
                var newtodo = new Todo(text.text);
                t.add(newtodo);
                text.clear();
              },
              child: Text('Add Todo'),
            ),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: Hive.box<Todo>('todo1').listenable(),
                    builder: (context, box, child) {
                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(box.getAt(index).item,style: TextStyle(fontSize: 22,color: Colors.green),),
                            trailing:  Icon(Icons.delete),
                            onTap: (){
                              box.deleteAt(index);
                            },
                          );
                        },
                      );
                    })),
          ],
        ));
  }
}
