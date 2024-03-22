import 'package:chatwave/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key,required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Stack(

    children:[
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(

            fit: BoxFit.fill,
            image: AssetImage("assets/images/a7829c5e3f4c8ea3810d24a064f6c0a1.jpg")
          )
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF2E4374),
        title:  Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage ("assets/images/profile.png"),
            ),
            const SizedBox(width: 10,),
            Text(userModel.name.toString(),style: const TextStyle(color: Colors.white),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                children: [
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xFF6E85B7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )
                      ),
                      child: const Center(
                        child: Text("Message",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white ),),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                          color: Color(0xFFF8F9D7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                      ),
                      child: const Center(
                        child: Text("Message reply",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0XFF2E4374) ),),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xFF6E85B7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )
                      ),
                      child: const Center(
                        child: Text("Message",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white ),),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: const BoxDecoration(
                          color: Color(0xFFF8F9D7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                      ),
                      child: const Center(
                        child: Text("Message reply",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0XFF2E4374) ),),
                      ),
                    ),
                  ),




                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(

                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30,vertical: 14),
                      suffixIcon: const Icon( Icons.attach_file,color: Color(0XFF2E4374),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color:  Color(0XFF2E4374))
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color:  Color(0XFF2E4374)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color:  Color(0XFF2E4374)),
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type a message...',
                     hintStyle: const TextStyle(color: Colors.grey,fontSize: 14)


                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                CircleAvatar(backgroundColor: const Color(0XFF2E4374),
                  child: IconButton(
                    icon: const Icon(Icons.mic,color: Colors.white ,),
                    onPressed: () {
                    },
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    ),
    ]
    );
  }
}


