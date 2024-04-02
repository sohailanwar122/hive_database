import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box('sohail').listenable(),
            builder: (context, box, _) {
              return ListTile(
                title: Text(box.get('name').toString() ?? "dddd"),
                trailing: IconButton(
                  onPressed: () {
                    // for deleting data
                    box.delete('name');
                    // for updating data
                    // snapshot.data!.put('name', 'ali wss');
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          ),

          // FutureBuilder(
          //     future: Hive.openBox('sohail'),
          //     builder: (context, snapshot)
          // {
          //   return ListTile(
          //     title: Text(snapshot.data?.get('name').toString() ?? "dddd"),
          //     trailing: IconButton(onPressed: () {
          //       // for deleting data
          //       snapshot.data!.delete('name');
          //       // for updating data
          //       // snapshot.data!.put('name', 'ali wss');
          //       setState(() {
          //
          //       });
          //     }, icon: Icon(Icons.delete),),
          //   );
          // }
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ///open hive here
          // var box = await Hive.openBox('sohail');
          /// get already opened hive in main
          var box = Hive.box('sohail');
           ///add data in hive
          box.put('name', 'haji');
          // setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
