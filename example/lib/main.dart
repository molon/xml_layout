import 'package:flutter/material.dart';
import 'package:xml_layout/xml_layout.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'test.xml_layout.dart' as xml_layout;
import 'package:xml_layout/types/colors.dart' as colors;
import 'package:xml_layout/types/icons.dart' as icons;
import 'package:xml_layout/types/function.dart';

void main() {
  colors.register();
  icons.register();
  xml_layout.register();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> _loadLayout(String path) {
  return rootBundle.loadString(path);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
          children: ListTile.divideTiles(tiles: [
        ListTile(
          title: Text("LayoutExample"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => _LayoutExample())),
        ),
        ListTile(
          title: Text("GridExample"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => _GridExample())),
        ),
        ListTile(
          title: Text("BuilderExample"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => _BuilderExample())),
        )
      ], context: context, color: Colors.black12)
              .toList()),
    );
  }
}

class _LayoutExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LayoutExampleState();
}

class _LayoutExampleState extends State<_LayoutExample> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Layout Example"),
      ),
      body: Center(
        child: FutureBuilder<String>(
            future: _loadLayout("assets/layout.xml"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return XmlLayout(
                  template: snapshot.data,
                  objects: {"counter": _counter},
                  onUnkownElement: (node, key) {
                    print("Unkown ${node.name ?? node.text}");
                  },
                );
              }
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _GridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _loadLayout("assets/grid.xml"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return XmlLayout(
              template: snapshot.data,
              objects: {
                "map": {
                  "pictures": [
                    "https://wx1.sinaimg.cn/mw2000/006a0Rdhly1gwspe674xtj32k61rb1l0.jpg",
                    "https://wx2.sinaimg.cn/mw2000/006a0Rdhly1gwspe98sz6j31rb2k6e83.jpg",
                    "https://wx1.sinaimg.cn/mw2000/006a0Rdhly1gwspeftogxj31le24b4qr.jpg"
                  ]
                },
                "print": (int idx) {
                  print("click ${idx}");
                }
              },
              onUnkownElement: (node, key) {
                print("Unkown ${node.name ?? node.text}");
              },
            );
          }
          return Container();
        });
  }
}

class _BuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List data = [
      {
        "title": "Title1",
        "subtitle": "Content1",
        "image":
            "https://wx2.sinaimg.cn/mw2000/006a0Rdhly1gwspejn1n3j31rb2k61l0.jpg"
      },
      {
        "title": "Title2",
        "subtitle": "Content2",
        "image":
            "https://wx4.sinaimg.cn/mw2000/006a0Rdhly1gwspemuz4pj31rb2k6e84.jpg"
      },
      {
        "title": "Title3",
        "subtitle": "Content3",
        "image":
            "https://wx2.sinaimg.cn/mw2000/006a0Rdhly1gwspep9xuoj31oz2grb2b.jpg"
      }
    ];
    return FutureBuilder<String>(
        future: _loadLayout("assets/list.xml"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return XmlLayout(
              template: snapshot.data,
              objects: {
                "title": "BuilderExample",
                "itemCount": data.length,
                "getItem": (int idx) {
                  return data[idx];
                },
                "print": (int idx) {
                  print("click $idx");
                }
              },
              onUnkownElement: (node, key) {
                print("Unkown ${node.name ?? node.text}");
              },
            );
          }
          return Container();
        });
  }
}
