import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


void main() {
  runApp(MaterialApp(
      home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var a = 1;
  var name = [];
  var heart = [0,0,0,0,0,0];

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      print(contacts);
      name = contacts;

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  // 시작하자마자
  void initState(){
    super.initState();
    getPermission();
  }

  addOne(){
    setState(() {
      a++;
    });
  }

  addUser(newUser){
    var newPerson = Contact();
    newPerson.givenName = newUser;
    newPerson.familyName = newUser ;
    ContactsService.addContact(newPerson);

    setState(() {
      name.add(newPerson);
      heart.add(0);
      print(name);
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        floatingActionButton: FloatingActionButton(
          child: Text(a.toString()),
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(state : a, addOne : addOne, addUser : addUser);
            });
          },
        ),


        appBar: AppBar(actions: [
          IconButton(onPressed: (){
            getPermission();
          }, icon: Icon(Icons.contacts))
        ],),


        body: ListView.builder(
            itemCount: name.length,
            itemBuilder: (context,i){
              return ListTile(
                leading: Text(heart[i].toString()),
                title: Text(name[i].givenName),
                trailing: TextButton(
                    onPressed: (){
                      setState(() {
                        heart[i]++;
                      });
                    },
                    child: Text("좋아요")
                ),
              );
            }
        )

      );
  }
}










class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.state,this.addOne,this.addUser}) : super(key: key);
  final state;
  final addOne;
  final addUser;
  var inputData = TextEditingController();
  var inputData2 = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("Contact"),
      content: TextFormField(
        onChanged: (text){
          inputData2 = text;
          print(inputData2);
        },
      ),
      actions: [
        TextButton(onPressed: (){
          addOne();
        }, child: Text("완료")
        ),
        TextButton(onPressed: (){
          Navigator.pop(context);
          addUser(inputData2);
        }, child: Text("OK")
        ),
      ],

    );
  }
}






// class ShopItem extends StatefulWidget {
//   const ShopItem({Key? key}) : super(key: key);
//
//   @override
//   State<ShopItem> createState() => _ShopItemState();
// }
//
// class _ShopItemState extends State<ShopItem> {
//   var name = ['김영숙', '홍길동','이성민'];
//   var heart = [0,0 ,0];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: 3,
//         itemBuilder: (context,i){
//           return ListTile(
//             leading: Text(heart[i].toString()),
//             title: Text(name[i]),
//             trailing: TextButton(
//                 onPressed: (){
//                   setState(() {
//                     heart[i]++;
//                   });
//                 },
//                 child: Text("좋아요")
//             ),
//           );
//         }
//     );
//   }
// }


