import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomePage(),
        "secondpage": (context) => SecondPage(),
      },
    );
  }
}

List<TextEditingController> n = [];
List<String> v = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> input = [];

  List<TextEditingController> textEditingControllers = [];
  List text = [];
  List<String> texttime = [
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 AM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    textEditingControllers.add(TextEditingController());

    input.add(getInput(Container(), 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Dairy App"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  n = textEditingControllers;
                  v = texttime;
                  Navigator.of(context).pushNamed(
                    "secondpage",
                  );
                });
              },
              icon: Icon(Icons.smart_display_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          textEditingControllers.add(TextEditingController());
          input.add(getInput(Container(), input.length));
          setState(() {});
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                child: Column(
                  children:
                      input.map((e) => getInput(e, input.indexOf(e))).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget getInput(Widget w, int i) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 400,
            child: TextFormField(
              controller: textEditingControllers[i],
              validator: (val) {
                if (val!.isEmpty) {
                  return "please enter note forst";
                }
              },
              onSaved: (val) {
                text = val as List;
              },
              decoration: InputDecoration(
                hintText: "${texttime[i]}",
                label: Text("${texttime[i]}"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

int i = 0;

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: n
                    .map((e) => pw.Container(
                          width: 400,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(20),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("${e.text}"),
                                pw.Text("${v[i++]}"),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Notes"),
        actions: [
          IconButton(
              onPressed: () async {
                final output = await getExternalStorageDirectory();
                print("path:" + output!.path);
                final file = File("${output.path}/n_resume.pdf");
                await file.writeAsBytes(await pdf.save());
              },
              icon: Icon(Icons.download)),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 30),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: n
                    .map((e) => Container(
                          margin: EdgeInsets.all(20),
                          color: Colors.blue,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${e.text}",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${v[i++]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
