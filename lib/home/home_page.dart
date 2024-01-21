import 'package:chatwave/home/widgets/find_widget.dart';
import 'package:flutter/material.dart';

import '../auth/widgets/custom_textfield.dart';
import '../chat/view/chat_page.dart';
import '../onboarding/view/onboarding_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0XFF2E4374),
        appBar: AppBar(
          backgroundColor: const Color(0XFF2E4374),
          title: Image.asset("assets/images/home logo.png",height: 50,),
          bottom: TabBar(
            overlayColor: const MaterialStatePropertyAll(Color(0xFFC4D7E0)),

            indicatorColor: Colors.white,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: -45),

            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle,
                border: Border.all(color: Colors.white,width: 3)),

            dividerColor: Colors.transparent,

            unselectedLabelColor: Colors.white,
            labelColor: const Color(0XFF2E4374),
            tabs: const [
              Tab(text: 'Chats'),
              Tab(text: 'Detect'),
              Tab(text: 'Settings'),
            ],
          ),

        centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Recent Chats",style: TextStyle(color: Color(0XFF2E4374),fontWeight: FontWeight.bold,fontSize: 18),),
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FindWidget(),));
                          }, icon: const Icon(Icons.search_rounded))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.7,
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                          return ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(),));
                            },
                            leading: Image.asset("assets/images/profile.png"),
                            title: const Text("User Name"),
                            subtitle: const Text("Messega content"),
                            trailing: const Text("message date"),
                          );
                        },),
                      )

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)
                    )
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                    Image.asset("assets/images/Yellow and Black Creative Illustration Chit Chat Logo (5).png"),
                    PrimaryButton(
                      onTap: (){},
                      bgColor: const Color(0XFF2E4374),
                      text: "Upload voice",
                      textColor: Colors.white,
                      height: 45,
                      width: MediaQuery.of(context).size.width*0.55,

                      borderRadius: 30,
                      fontSize: 16,
                    ) ,
                    const SizedBox(height: 25,),
                    const Text("Uploaded Audio",style: TextStyle(fontSize: 16),),
                    const SizedBox(height: 25,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("This Audio Is Real",style: TextStyle(color: Color(0xFF6E85B7),fontSize: 20,fontWeight: FontWeight.bold),),
                        Icon(Icons.check,color: Colors.green,)
                      ],
                    ),




                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)
                    )
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    const Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xFF6E85B7),
                          backgroundImage: AssetImage(
                              "assets/images/profile.png"
                          ),
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFF8F9D7),
                          child: Center(
                            child: Icon(
                              Icons.edit,color: Color(0XFF2E4374),
                            ),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Edit Name",style: TextStyle(color:Color(0XFF2E4374),fontSize: 20,fontWeight: FontWeight.bold ),),
                        SizedBox(width: 5,),
                        Icon(Icons.edit)
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    const CutomTextField(
                      hintText: "Edit Name",
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add Phone Number",style: TextStyle(color:Color(0XFF2E4374),fontSize: 20,fontWeight: FontWeight.bold ),),
                        SizedBox(width: 5,),
                        Icon(Icons.edit)
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    const CutomTextField(
                      hintText: "Phone Number",
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    PrimaryButton(
                      onTap: (){},
                      bgColor: const Color(0XFF2E4374),
                      text: "Logout",
                      textColor: Colors.white,
                      height: 45,
                      width: MediaQuery.of(context).size.width*0.55,

                      borderRadius: 30,
                      fontSize: 16,
                    ) ,




                  ],
                ),
              ),
            ),
          ],
        ),



      ),
    );
  }
}
