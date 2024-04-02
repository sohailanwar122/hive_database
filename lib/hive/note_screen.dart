import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../box/box.dart';
import '../models/notes_model.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<Color> colors = [Colors.purple , Colors.black38, Colors.green, Colors.blue , Colors.red] ;
  Random random = Random(3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box ,_){
          var data = box.values.toList().cast<NotesModel>();
          if(data.isNotEmpty)
            {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
                itemCount: box.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index){


                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: colors[random.nextInt(4)],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Text(data[index].title.toString(),
                                    style: const TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () {
                                        delete(data[index]);
                                      },
                                      child: const Icon(
                                        Icons.delete, color: Colors.white,)),
                                  const SizedBox(width: 15,),
                                  InkWell(
                                      onTap: () {
                                        _editDialog(data[index],
                                            data[index].title.toString(),
                                            data[index].description.toString());
                                      },
                                      child: const Icon(
                                        Icons.edit, color: Colors.white,)),

                                ],
                              ),
                              Text(data[index].description.toString(),
                                style: const TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }



            ),
          );
    }
    else
    {
    return const Center(child: Text('Todo is Empty', ));
    }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  /// save data in hive
  Future<void> _showMyDialog()async{
    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: const Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: (){
                final data = NotesModel(title: titleController.text,
                    description: descriptionController.text) ;

                final box = Boxes.getData();
                box.add(data);
                data.save() ;

                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              }, child: const Text('Add')),
            ],
          );
        }
    ) ;
  }


  /// delete data from hive
  void delete(NotesModel notesModel)async
  {
    await notesModel.delete();
  }



  /// edit data in hive
  Future<void> _editDialog(NotesModel notesModel, String title, String description)async{

    titleController.text = title ;
    descriptionController.text = description ;

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: ()async{

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                notesModel.save();
                descriptionController.clear() ;
                titleController.clear() ;


                Navigator.pop(context);
              }, child: Text('Edit')),
            ],
          );
        }
    ) ;
  }

}
