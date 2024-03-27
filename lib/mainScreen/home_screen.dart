import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/model/menus.dart';
import 'package:lapo_try/uploadScreens/menu_upload_screen.dart';
import 'package:lapo_try/widgets/info_design.dart';
import 'package:lapo_try/widgets/my_drawer.dart';
import 'package:lapo_try/widgets/progress_bar.dart';
import 'package:lapo_try/widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                icon: const Icon(Icons.post_add, color: Colors.white,),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const MenusUploadScreen()));
                },
              ),
            ],
          ),
        body: CustomScrollView(
          slivers: [
           SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My Menus",)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection("sellers")
              .doc(sharedPreferences!.getString("uid"))
              .collection("menus",)
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
                          Menus model = Menus.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                          );
                          return InfoDesignWidget(
                            model: model, 
                            context: context,
                          );
                        },
                      itemCount: snapshot.data!.docs.length,
                    );
              },
            ),
          ],
        ),
    );
  }
}