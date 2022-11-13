

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAvatar extends StatelessWidget {
   CustomAvatar({Key? key,this.adress="",this.maxradius}) : super(key: key);
   final double? maxradius;
   final String? adress;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      height: maxradius,
      width: maxradius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue
      ),
      child: getUserAvatar(adress?? ""),
    );
  }
   getUserAvatar(url) {
     return url==null||url==""?
    Center( child: FaIcon(FontAwesomeIcons.image,color: Colors.grey,))
         :Image.network(url);
   }
}
