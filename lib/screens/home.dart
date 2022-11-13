import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interview/data/user.dart';
import 'package:interview/data/mock_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interview/widgets/avatar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool show=false;
  final searchTypes=["searchByFirstName","searchByLastName","searchByRole","searchByEmail"];
  TextEditingController searchController = TextEditingController();
  var users = User.fromJsonToList(allData());
  List<User> searchList=[];
  String? selectedSearchType;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _filterList() {}

  @override
  Widget build(BuildContext context) {
    _getUserAvatar(url) {
      print(url);
      return url==null||url==""?
        CircleAvatar(
          child:  FaIcon(FontAwesomeIcons.image,color: Colors.grey,),
        )
      :CircleAvatar(backgroundImage: NetworkImage(url));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                onChanged:onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: selectedSearchType??"Serach By Name",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  suffixIcon: IconButton(
                    icon:Icon(Icons.filter_alt,color: Colors.white,),
                    onPressed: (){
                      show=!show;
                      setState(() {
                      });
                    },
                  )
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          show?AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.only(
                left: 30, top: 20, bottom: 20, right: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              // color: Color(0xFFE9EAEA),
            ),
            child: Column(
              children: [
                Text("Select Filter",style: TextStyle(color: Colors.blue,fontSize: 18),),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: ListView.separated(
                    itemCount: searchTypes.length,
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(searchTypes[index]),
                        value: searchTypes[index],
                        groupValue: selectedSearchType,
                        onChanged: (value){
                          setState(() {
                            selectedSearchType = value.toString();
                            show=false;
                            setState(() {});
                            print(selectedSearchType);
                          });
                        },
                      );
                    },
                    separatorBuilder: (context , index){
                      return const SizedBox();
                    },),
                ),
              ],
            ),
          ):SizedBox(),

          Flexible(
            child: searchList.isEmpty?ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final item = users[index];
                return ListTile(
                  //leading: _getUserAvatar(item.avatar),
                  leading: CustomAvatar(
                    maxradius: 40,
                    adress: item.avatar,
                  ),
                  title: Text('${item.firstName}  ${item.lastName}'),
                  subtitle: Text(
                    '${item.role}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ):ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                final item = searchList[index];
                return ListTile(
                  //leading: _getUserAvatar(item.avatar),
                  leading: CustomAvatar(
                    maxradius: 40,
                    adress: item.avatar,
                  ),
                  title: Text('${item.firstName}  ${item.lastName}'),
                  subtitle: Text(selectedSearchType=="searchByEmail"?"EMAIL: ${item.email}":
                    'ROLE: ${item.role}',
                    style: TextStyle(color: Colors.blue),
                  ),
                  trailing: IconButton(
                    icon:Icon(Icons.delete,color: Colors.red,size: 20,),
                    onPressed: (){
                      searchList.removeAt(index);
                      searchController.text="";
                      searchController.clear();
                      searchList= [];
                      FocusScope.of(context).unfocus();
                      print(searchController.text);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var newUser = User(
              id: "b32ec56c-21bb-4b7b-a3a0-635b8bca1f9d",
              avatar: null,
              firstName: "James",
              lastName: "May",
              email: "ssaull1c@tripod.com",
              role: "Developer");
          await addNewUser(newUser);

          setState(() {});

        },
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ),
    );
  }

  addNewUser(User newUser) {
    users.add(newUser);
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: const Text('user added succefully'),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.black,
        onPressed: () {
          Navigator.of(context);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print("user added succefully");
    setState(() {});
  }


  onSearchTextChanged(String text) async {
    searchList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    if(selectedSearchType=="searchByLastName"){
      users.forEach((User) {
        if (User.lastName.toLowerCase().contains(text.toLowerCase())) searchList.add(User);
      });
    }else if(selectedSearchType=="searchByRole"){
      users.forEach((User) {
        if (User.role.toLowerCase().contains(text.toLowerCase())) searchList.add(User);
      });
    }else if(selectedSearchType=="searchByEmail"){
      users.forEach((User) {
        if (User.email.toLowerCase().contains(text.toLowerCase())) searchList.add(User);
      });
    }else{
      users.forEach((User) {
        if (User.firstName.toLowerCase().contains(text.toLowerCase())) searchList.add(User);
      });
    }
    print(searchList.length);
    setState(() {});
  }
}
