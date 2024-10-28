
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wow_codes/Usefull/Colors.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';


import '../Config/Config.dart';


class ItemAdapter extends StatefulWidget {
  List Products;
  ItemAdapter({super.key,required this.Products}
      );

  @override
  State<ItemAdapter> createState() => _ItemAdapterState();
}

class _ItemAdapterState extends State<ItemAdapter> {




  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) {
      return 5; // For wide screens (like large desktops)
    } else if (screenWidth >= 900) {
      return 4; // For medium screens (like tablets in landscape)
    } else if (screenWidth >= 600) {
      return 3; // For smaller tablets
    } else {
      return 2; // For phones and small screens
    }
  }
  @override
  Widget build(BuildContext context) {
    // return GridView.c
    return WaterfallFlow.builder(
      itemCount: widget.Products.length,
        //cacheExtent: 0.0,
        padding: EdgeInsets.all(5.0),
    itemBuilder: (context,i){
        print(widget.Products[i]);
          return item_widget(data: widget.Products[i]);
    },
    gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
    crossAxisCount: calculateCrossAxisCount(context),
    crossAxisSpacing: 10.0,
    mainAxisSpacing:10.0,

    lastChildLayoutTypeBuilder: (index) => index == widget.Products.length
    ? LastChildLayoutType.foot
        : LastChildLayoutType.none,
    ));
  }

  @override
  void initState() {
    print(widget.Products);
  }
}

class item_widget extends StatefulWidget {
  Map data;
  item_widget({super.key,required this.data});

  @override
  State<item_widget> createState() => _item_widgetState();
}

class _item_widgetState extends State<item_widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color:lightgrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          CachedNetworkImage(
            imageUrl: thumbnailUrl + widget.data['product_image'],
            width: MediaQuery.of(context).size.width * 0.40,
            placeholder: (context, url) => Image.asset("assets/placeholder.jpg"),
          ),
          // Image.network(thumbnailUrl + widget.data['product_image'],width: MediaQuery.of(context).size.width * 0.40,),
          mainTextLeft(widget.data['product_name'], Colors.grey, 13.0, FontWeight.normal,2, "mons"),
          Row(
            children: [
              Expanded(child: mainTextLeft("\$" + widget.data['product_list_price'], Colors.black, 20.0, FontWeight.bold,1, "mons")),
              IconButton(onPressed: (){}, icon: Icon(Iconsax.heart))
            ],
          ),
        ],
      ),
    );
  }
}

