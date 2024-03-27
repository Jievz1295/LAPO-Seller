import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_try/assistantMethod/assistant_methods.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/widgets/order_card.dart';
import 'package:lapo_try/widgets/progress_bar.dart';
import 'package:lapo_try/widgets/simple_app_bar.dart';

class NewOrdersScreen extends StatefulWidget 
{

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}


class _NewOrdersScreenState extends State<NewOrdersScreen> 
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "New Orders",),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection("orders")
          .where("status", isEqualTo: "normal")
          .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
          .snapshots(),
        builder: (c, snapshot)
        {
          return snapshot.hasData 
              ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (c, index) 
                {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("items")
                        .where("itemID", whereIn: separateOrdersItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                        .where("SellerUID", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                        .orderBy("publishedDate", descending: true)
                        .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData 
                            ? OrderCard(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderID: snapshot.data!.docs[index].id,
                          separateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                        ) 
                            : Center(child: circularProgress());
                      },
                  );
                },
              ) 
              : Center(child: circularProgress(),);
         },

        ),
      ));
  }
}