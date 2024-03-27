import "package:flutter/material.dart";
import "package:lapo_try/mainScreen/item_detail_screen.dart";
import "package:lapo_try/model/items.dart";

// ignore: must_be_immutable
class ItemsDesignWidget extends StatefulWidget {

  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});
  

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemDetailScreen(model: widget.model)));
      },
      splashColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1,),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.brown,
                  fontSize: 25,
                  fontFamily: "Varela",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2.0,),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
             Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 56, 56, 56),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 1.0,),
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
