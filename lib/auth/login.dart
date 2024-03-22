import 'package:chatwave/auth/manager/auth_cubit.dart';
import 'package:chatwave/auth/signup.dart';
import 'package:chatwave/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../onboarding/view/onboarding_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => AuthCubit(),
  child: BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    AuthCubit cubit = AuthCubit.get(context);
    return Scaffold(
      // bottomSheet: Padding(
      //   padding:
      //   const EdgeInsets.only(top: 65, left: 32, right: 32, bottom: 57),
      //   child: PrimaryButton(
      //     onTap: (){
      //       cubit.login(email: cubit.emailLoginController.text, password: cubit.passwordLoginController.text, context: context);
      //     },
      //     bgColor: const Color(0XFF2E4374),
      //     text: "Login",
      //     textColor: Colors.white,
      //     height: 45,
      //     width: MediaQuery.of(context).size.width*0.75,
      //
      //     borderRadius: 30,
      //     fontSize: 16,
      //   ) ,
      // ),

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
                  
                       CutomTextField(
                        hintText: "Email Address",
                        controller: cubit.emailLoginController,
                        prefixIcon: const Icon(Icons.email_outlined,color: Colors.grey,),
                      ),
                      const SizedBox(height: 20,),
                       CutomTextField(
                         controller: cubit.passwordLoginController,

                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline_rounded,color: Colors.grey,),
                        sufixIcon:const Icon(Icons.remove_red_eye_outlined,color: Colors.grey,) ,
                      ),
                      const SizedBox(height: 40,),
                      PrimaryButton(
                        onTap: (){
                          cubit.login(email: cubit.emailLoginController.text, password: cubit.passwordLoginController.text, context: context);
                        },
                        bgColor:  const Color(0xFFB2C8DF),
                        text: "Login",
                        textColor: Colors.white,
                        height: 45,
                        width: MediaQuery.of(context).size.width*0.75,

                        borderRadius: 30,
                        fontSize: 16,
                      ) ,
                      const SizedBox(height: 20,),


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
  },
),
);
  }
}
