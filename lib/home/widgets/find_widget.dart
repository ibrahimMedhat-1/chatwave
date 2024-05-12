import 'package:chatwave/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/widgets/custom_textfield.dart';
import '../../chat/view/chat_page.dart';

class FindWidget extends StatelessWidget {
  const FindWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getUsers();
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
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  CutomTextField(
                    onChanged: (value) {
                      if (value == null || value.isEmpty) {
                        cubit.isNotSearching();
                      } else {
                        cubit.searchUsers(value);
                      }
                    },
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userModel2: cubit.users[index],
                                  ),
                                ));
                          },
                          leading: cubit.users[index].image! == ''
                              ? const Material(
                                  elevation: 4,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/profile.png'),
                                  ),
                                )
                              : Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(cubit.users[index].image!.toString()),
                                  ),
                                ),
                          title: Text(cubit.users[index].name!),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
