import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_try/mainScreen/order_details_screen.dart';
import 'package:lapo_try/model/items.dart';

class OrderCard extends StatelessWidget 
{
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? separateQuantitiesList;

  OrderCard({
    this.itemCount,
    this.data,
    this.orderID,
    this.separateQuantitiesList
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> OrderDetailsScreen(orderID: orderID)));
      },
      child: Container(
        decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black12,
                  Colors.white54,
                ],
                begin: FractionalOffset(0.0, 0.8),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            height: itemCount! * 125,
            child: ListView.builder(
              itemCount: itemCount,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index)
              {
                Items model = Items.fromJson(data![index].data()!as Map<String, dynamic>);
                return placeOrderDesignWidget(model, context, separateQuantitiesList![index]);
              },
          ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(Items model,BuildContext context, separateQuantitiesList)
{
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(model.thumbnailUrl!, width: 120,),
        const SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Acme",
                        fontSize: 16,
                      ),
                    ),
                    ),
                    const SizedBox(
                      width: 10,
                  ),
                  const Text(
                    "RM ",
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.blue),
                  ),
                  Text(
                    model.price.toString(),
                    style: const TextStyle(
                      fontSize: 18.0, 
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  const Text(
                    "x ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      separateQuantitiesList,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontFamily: "Acme",
                        fontSize: 30,
                      ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          ),
      ],
    ),
  );
}