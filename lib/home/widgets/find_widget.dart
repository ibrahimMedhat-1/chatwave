import 'package:chatwave/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/widgets/custom_textfield.dart';

class FindWidget extends StatelessWidget {
  const FindWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0XFF2E4374),
            title: Image.asset(
              "assets/images/home logo.png",
              height: 50,
            ),
            centerTitle: true,
          ),
          backgroundColor: const Color(0XFF2E4374),
          body: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    CutomTextField(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: cubit.allUsers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset("assets/images/profile.png"),
                            title: Text(cubit.allUsers[index].name!),
                            subtitle: Text(cubit.allUsers[index].email!),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
