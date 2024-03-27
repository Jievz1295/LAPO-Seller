import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/model/items.dart';
import 'package:lapo_try/model/menus.dart';
import 'package:lapo_try/uploadScreens/items_upload_screen.dart';
import 'package:lapo_try/widgets/items_design.dart';
import 'package:lapo_try/widgets/my_drawer.dart';
import 'package:lapo_try/widgets/progress_bar.dart';
import 'package:lapo_try/widgets/text_widget_header.dart';


class ItemsScreen extends StatefulWidget 
{

  final Menus? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                   Color.fromARGB(255, 175, 0, 0),
                 Colors.white,
                 
                ],
                begin: FractionalOffset(1.0, 0.8),
                end: FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
                icon: const Icon(Icons.library_add, color: Colors.white,),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsUploadScreen(model: widget.model)));
                },
              ),
            ],
          ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "" + widget.model!.menuTitle.toString() + "'s Items")),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection("sellers")
              .doc(sharedPreferences!.getString("uid"))
              .collection("menus",).doc(widget.model!.menuID)
              .collection("items")
              .orderBy("publishedDate", descending: true)
              .snapshots(),
            builder: (context, snapshot) 
            {
                return !snapshot.hasData 
                    ? SliverToBoxAdapter(
                      child: Center(child: circularProgress(),),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) 
                        {
                          Items model = Items.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                          );
                          return ItemsDesignWidget(
                            model: model, 
                            context: context,
                          );
                        },
                      itemCount: snapshot.data!.docs.length,
                    );
              },
            ),
        ],
      )
    );
  }
}