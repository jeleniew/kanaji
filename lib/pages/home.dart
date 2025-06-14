// home.dart

import 'package:flutter/material.dart'; // komponenty do budowy widoków
import 'package:kanaji/widgets/app_drawer.dart';
import 'package:kanaji/widgets/app_bar.dart';


class HomePage extends StatelessWidget {  // Stateless - zawartosć się nie zmienia po uruchomieniu
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: appDrawer(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child:Text(
            '世こそ!',
            style: TextStyle(
              fontSize: 64,
            ), 
          ),
        )
      )
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     _searchField(),
      //     SizedBox(height: 40,),
      //     Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(left: 20),
      //           child: Text(
      //             'Category',
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 18,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         )
      //       ]
      //     ),
      //   ],
      // ),
    );
  }


  // Widget _buildAppBarIcon(VoidCallback onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: EdgeInsets.all(10),
  //       alignment: Alignment.center,
  //       width: 37,
  //       child: SvgPicture.asset(
  //         'assets/icons/menu_24dp.svg', // TODO: źródło: https://fonts.google.com/icons
  //       ),
  //       decoration: BoxDecoration(
  //         color: Color(0xffF7F8F8),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //   );
  // }

  // Widget _searchField() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 40, left: 20, right: 20),
  //     // decoration: BoxDecoration(
  //     //   boxShadow: [
  //     //     BoxShadow(
  //     //       color: Color(0xff1D1617).withValues()  // TODO: change this
  //     //     )
  //     //   ]
  //     // ),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         filled: true,
  //         fillColor: Colors.white,
  //         hintText: 'Search Pancake',
  //         hintStyle: TextStyle(
  //           color: Color(0xffDDDADA),
  //           fontSize: 14,
  //         ),
  //         prefixIcon: Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: SvgPicture.asset('assets/icons/Search.svg')
  //         ),
  //         suffixIcon: SizedBox(  // TODO
  //           width: 100,
  //           child: IntrinsicHeight(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 VerticalDivider(
  //                   color: Colors.black,
  //                   indent: 10,
  //                   endIndent: 10,
  //                   thickness: 0.1,
  //                 ),
  //                 Padding(padding: const EdgeInsets.all(8.0),
  //                 child: SvgPicture.asset('assets/icons/Filter.svg'),
  //                 )
  //               ]
  //             )
  //           ),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           borderSide: BorderSide.none
  //         )
  //       ),
  //     ),
  //   );
  // }
}