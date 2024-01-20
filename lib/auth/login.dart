import 'package:chatwave/auth/signup.dart';
import 'package:chatwave/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../onboarding/view/onboarding_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding:
        const EdgeInsets.only(top: 65, left: 32, right: 32, bottom: 57),
        child: PrimaryButton(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
          },
          bgColor: const Color(0XFF2E4374),
          text: "Login",
          textColor: Colors.white,
          height: 45,
          width: MediaQuery.of(context).size.width*0.75,

          borderRadius: 30,
          fontSize: 16,
        ) ,
      ),

      body: Column(
        children: [
          Center(
            child: Image.asset("assets/images/logo.png",height: 350,),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0XFF2E4374),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                )

              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                  child: Column(
                  
                    children: [
                      const Text('Login',style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.bold),),
                      SizedBox(height: MediaQuery.of(context).size.width*0.1,),
                  
                      const CutomTextField(
                        hintText: "Email Address",
                        prefixIcon: Icon(Icons.email_outlined,color: Colors.grey,),
                      ),
                      const SizedBox(height: 20,),
                      const CutomTextField(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.grey,),
                        sufixIcon:Icon(Icons.remove_red_eye_outlined,color: Colors.grey,) ,
                      ),
                      const SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage(),));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't Have Account? ",style: TextStyle(color: Colors.white,fontSize: 12,)),
                            Text("Signup",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ),
          )
        ],
      ),
    );
  }
}
