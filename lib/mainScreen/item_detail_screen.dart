import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/model/items.dart';
import 'package:lapo_try/splashScreen/splash_screen.dart';
import 'package:lapo_try/widgets/simple_app_bar.dart';

class ItemDetailScreen extends StatefulWidget 
{
 final Items? model;
 const ItemDetailScreen({super.key, this.model});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> 
{
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID)
  {
    FirebaseFirestore.instance
    .collection("sellers")
    .doc(sharedPreferences!.getString("uid"))
    .collection("menus")
    .doc(widget.model!.menuID!)
    .collection("items")
    .doc(itemID)
    .delete().then((value)
    {
      FirebaseFirestore.instance
      .collection("items")
      .doc(itemID)
      .delete();
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
      Fluttertoast.showToast(msg: "Item has been Deleted Successfully");
    });
  }

  @override
  Widget build(BuildContext context) 
  {
 return Scaffold(
  appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(widget.model!.thumbnailUrl.toString()),
       
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.model!.title.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
          ),
        ),

         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.model!.shortInfo.toString(),
            style: const TextStyle(color: Colors.black54, fontSize: 19,),
          ),
        ),

         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.model!.longDescription.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "RM ${widget.model!.price}",
            style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        
        const SizedBox(height: 10,),
        
        Center(
          child: InkWell(
            onTap: ()
            {
              //delete item
              deleteItem(widget.model!.itemID!);
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                  Color.fromARGB(255, 206, 14, 14),
                  Colors.yellow,
            
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
              ),
              //width: MediaQuery.of(context).size.width - 40,
              height: 50,
              child: const Center(
                child: Text(
                  "Delete this Item",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: "Acme"),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

  }
}