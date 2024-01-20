import 'package:flutter/material.dart';

import '../../auth/widgets/custom_textfield.dart';

class FindWidget extends StatelessWidget {
  const FindWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0XFF2E4374),
        title: Image.asset("assets/images/home logo.png",height: 50,),
        centerTitle: true,
      ),
      backgroundColor: const Color(0XFF2E4374),
      body:  Expanded(
        child: Padding(
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
                const CutomTextField(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.7,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset("assets/images/profile.png"),
                        title: const Text("User Name"),
                        subtitle: const Text("User Email"),

                      );
                    },),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
