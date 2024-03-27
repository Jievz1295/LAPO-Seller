import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/mainScreen/items_screen.dart';
import 'package:lapo_try/model/menus.dart';

// ignore: must_be_immutable
class InfoDesignWidget extends StatefulWidget 
{
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});


  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}



class _InfoDesignWidgetState extends State<InfoDesignWidget> 
{
  deleteMenu(String MenuID)
  {
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(MenuID)
        .delete();

    Fluttertoast.showToast(msg: "Menu has been Deleted Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 340,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 40,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.menuTitle!,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 25,
                      fontFamily: "Varela",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: ()
                    {
                      //delete menu
                      deleteMenu(widget.model!.menuID!);
                    },
                  ),
                ],
              ),

              //Text(
              //  widget.model!.menuInfo!,
              //  style: const TextStyle(
              //    color: Color.fromARGB(255, 56, 56, 56),
              //    fontSize: 12,
              //    //fontFamily: "Kiwi",
              //  ),
              //),

              Divider(
                height: 10,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
        ),
    );
  }
}