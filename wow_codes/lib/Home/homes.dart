
import 'package:flutter/material.dart';
import 'package:wow_codes/Config/Config.dart';
import 'package:wow_codes/Helper/Helper.dart';
import 'package:wow_codes/Home/item_adapter.dart';
import 'package:wow_codes/Usefull/Buttons.dart';
import 'package:wow_codes/Usefull/Colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';



class Homes extends StatefulWidget {
  const Homes({super.key});

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> with SingleTickerProviderStateMixin{
  String search = "";
  int _selectedIndex = 0;
  late TabController _tabController;
  bool isHide = false;


  changeSelected(int i){
    setState(() {
      // _selectedIndex = i;

      _tabController.animateTo(i,duration: Duration(milliseconds: 100));
    });
  }

  final List<String> images = [
    "https://i.ytimg.com/vi/ye34D-imtSQ/maxresdefault.jpg",
    "https://images.khmer24.co/23-09-18/s-new-nike-style-shoes-soft-and-comfortable-to-wear-no-foot-pain-for-running-shoes-men-and-women-719056169500332377723249-e.jpg"
  ];

  int _currentIndex = 0;
  Map allData = {};
  Map userData = {};




  @override
  void initState() {
    getData();// 4 tabs
  }

  getData() async{
    setState(() {
      isHide = true;
    });

    allData = await getHomData();
    userData = await Helper().getUserData();
    print("data is $allData");
    _tabController = TabController(length: allData['categories'].length - 1, vsync: this);
    setState(() {
      isHide = false;
    });
  }

  int catid = 0;

  @override
  Widget build(BuildContext context) {
    return (allData.isNotEmpty)?DefaultTabController(

      length: 4,
      child: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0.0),
            child: NestedScrollView(

                headerSliverBuilder: (context,value){
                  return
                    [
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mainText("Hello, ${userData['user_name']}", Colors.grey, 15.0, FontWeight.normal, 1, "mons"),
                                  mainText("Welcome Back!", Colors.black, 20.0, FontWeight.bold, 1, "mons"),
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Iconsax.shopping_cart,color: Colors.black,))
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 20.0,)),

                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50.0,
                                child: TextFormField(
                                  autofocus: false,
                                  maxLength: 128,
                                  keyboardType:TextInputType.text,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    fontFamily: 'pop',
                                    fontSize: 13.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: false,
                                      counterText: "",
                                      prefixIcon: Icon(Iconsax.search_normal,color: Colors.grey,),
                                      hintText: "What you need",
                                      hintStyle: TextStyle(
                                          fontFamily: 'pop',
                                          color:Colors.grey
                                      ),

                                      errorStyle: TextStyle(
                                          fontFamily: 'mons',
                                          color: Colors.redAccent
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13.0)),
                                          borderSide:
                                          BorderSide(color: Colors.redAccent)),

                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13.0)),
                                          borderSide:
                                          BorderSide(color: Colors.black)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13.0)),
                                          borderSide:
                                          BorderSide(color: Colors.grey)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(13.0)),
                                          borderSide:
                                          BorderSide(color: Colors.grey,width: 0.5))),


                                  onChanged: (text){
                                    search = text;
                                  },
                                  validator: (value){

                                  },
                                ),

                              ),
                            ),

                            SizedBox(width: 10.0,),
                            Container(
                                height: 50.0,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.black,
                                  onPressed: (){},child: Icon(Iconsax.filter,color: Colors.white,),)),


                          ],
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 20.0,)),

                      SliverToBoxAdapter(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: (MediaQuery.of(context).size.width > 900)?5:2,
                            autoPlay: true,
                            enlargeCenterPage:true,
                            enlargeFactor:0.5,
                            viewportFraction: (MediaQuery.of(context).size.width > 900)?0.5:1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index; // Update the current index
                              });
                            },
                          ),
                          items: [
                            ...allData['banners'].map((e) {
                              // print(e);
                              return carousal_Item(data: e);
                            })
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 10.0)),
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // children: [
                          //   ...allData['banners'].map((e,) {
                          //      return GestureDetector();
                          //   })
                          // ],
                          children:allData['banners'].asMap().entries.map<Widget>((entry) {
                            return GestureDetector(
                              onTap: () => _onDotTap(entry.key), // Optional: Allow tap to change page
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? Colors.black // Active dot color
                                      : Colors.grey, // Inactive dot color
                                ),
                              ),
                            );
                          }).toList()
                          // children: allData['banners'].toList().asMap().entries.map((entry) {
                          //   return GestureDetector(
                          //     onTap: () => _onDotTap(entry.key), // Optional: Allow tap to change page
                          //     child: Container(
                          //       width: 8.0,
                          //       height: 8.0,
                          //       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: _currentIndex == entry.key
                          //             ? Colors.black // Active dot color
                          //             : Colors.grey, // Inactive dot color
                          //       ),
                          //     ),
                          //   );
                          // }).toList(),
                        ),
                      ),
                    ];
                }, body: Column(
              children: [
                Container(
                  // height: 40.0,
                  padding: EdgeInsets.only(top:10),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,

                    indicatorColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      ...allData['categories'].where((cc) => cc['category_id'] != "1" ).toList().map((e) {

                        int c = int.parse(e['category_id']) - 2;

                        // print(c);
                        return tabBarItem(() {changeSelected(c);}, e, Colors.black, Colors.white, 30, _tabController.index == c); // selected

                      }), // not selected
                    ],
                  ),

                ),

                SizedBox(height: 20.0,),

                Expanded(
                  child: TabBarView(
                    // physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,

                    children: [
                      ...allData['categories'].where((c) => c['category_id'] != "1").toList().map((e) {
                        // int c = int.parse(e['category_id']);
                        // return ItemAdapter(Products: allData['products']);
                        print(e['category_id']);
                        return ItemAdapter(Products: allData['products'].where((ee) => ee['product_category'] == e['category_id']).toList(),);
                      })


                    ],),
                )
              ],
            )),
          ),

          loaderss(isHide, context)

        ],
      ),
    ):loaderss(true, context);
  }

  void _onDotTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


class tabBarItem extends StatelessWidget {
  VoidCallback callback;
  Map data;
  Color main;
  Color text;
  double r;
  bool isSelected;

  tabBarItem(this.callback, this.data,this.main, this.text, this.r, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return (isSelected)?AnimatedContainer(
      duration: Duration(milliseconds: 300), // Animation duration
      height: 40.0,
      padding: EdgeInsets.only(right: isSelected ? 0.0 : 0), // Adjust padding smoothly
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: LinearGradient(
            colors: [
              Colors.grey, // Start color of gradient
              Colors.black, // Start color of gradient
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: text,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(thumbnailUrl + data['category_image']),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isSelected ? 5.0 : 0.0,
                ),
                if (isSelected)
                  AnimatedOpacity(
                    opacity: isSelected ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: onlymainText(data['category_name'], text, 12.0, FontWeight.normal, 1, "mons"),
                  ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(0, 0, (isSelected) ? 10 : 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            backgroundColor: Colors.transparent, // Important to make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
          ),
          onPressed: callback,
        ),
      )
    ):FloatingActionButton(
      mini: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(thumbnailUrl + data['category_image']),
        ),

        onPressed: callback);
  }
}

class carousal_Item extends StatelessWidget {
  Map data;
  carousal_Item({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(

          image: CachedNetworkImageProvider(imageUrl + "/thumbs/" + data['banner_image']),fit: BoxFit.contain,)
            // image: NetworkImage(imageUrl + "/thumbs/" + data['banner_image']),fit: BoxFit.contain)
        // image: DecorationImage(image: NetworkImage(imageUrl + "?" + data['banner_image']),fit: BoxFit.cover)
      ),
      width: MediaQuery.of(context).size.width,
      // child: Image.network(img),
    );
  }
}


