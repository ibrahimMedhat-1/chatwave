import 'package:chatwave/constants.dart';
import 'package:chatwave/home/manager/home_cubit.dart';
import 'package:chatwave/home/widgets/find_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/widgets/custom_textfield.dart';
import '../chat/view/chat_page.dart';
import '../onboarding/view/onboarding_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0XFF2E4374),
            appBar: AppBar(
              backgroundColor: const Color(0XFF2E4374),
              title: Image.asset(
                "assets/images/home logo.png",
                height: 50,
              ),
              bottom: TabBar(
                overlayColor: const MaterialStatePropertyAll(Color(0xFFC4D7E0)),
                indicatorColor: Colors.white,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: -45),
                indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.white, width: 3)),
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.white,
                labelColor: const Color(0XFF2E4374),
                onTap: (v) {
                  if (v == 0) {
                    HomeCubit.get(context).getUsersChats();
                  }
                },
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
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent Chats",
                                  style: TextStyle(
                                      color: Color(0XFF2E4374), fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const FindWidget(),
                                          ));
                                    },
                                    icon: const Icon(Icons.search_rounded))
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                itemCount: cubit.privateChatUser.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      print('here:${cubit.privateChatUser[index].id}');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              userModel2: cubit.privateChatUser[index],
                                            ),
                                          ));
                                    },
                                    leading: cubit.privateChatUser[index].image! == ''
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
                                              backgroundImage: NetworkImage(
                                                  cubit.privateChatUser[index].image!.toString()),
                                            ),
                                          ),
                                    title: Text(cubit.privateChatUser[index].name!),
                                    subtitle: Text(cubit.privateChatUser[index].lastMessage.toString()),
                                    trailing: Text(cubit.privateChatUser[index].lastMessageDate.toString()),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Image.asset(
                              "assets/images/Yellow and Black Creative Illustration Chit Chat Logo (5).png"),
                          PrimaryButton(
                            onTap: () {
                              cubit.pickAndUploadAudio();
                            },
                            bgColor: const Color(0XFF2E4374),
                            text: "Upload voice",
                            textColor: Colors.white,
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.55,
                            borderRadius: 30,
                            fontSize: 16,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            "Uploaded Audio",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "This Audio Is Real",
                                style: TextStyle(
                                    color: Color(0xFF6E85B7), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            ],
                          ),
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
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                          Stack(
                            children: [
                              userModel!.image == ''
                                  ? const Material(
                                      elevation: 4,
                                      shape: CircleBorder(),
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: AssetImage('assets/images/profile.png'),
                                      ),
                                    )
                                  : Material(
                                      elevation: 4,
                                      shape: const CircleBorder(),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        backgroundImage: NetworkImage(userModel!.image.toString()),
                                        radius: 80,
                                      ),
                                    ),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFFF8F9D7),
                                child: Center(
                                    child: IconButton(
                                  onPressed: () {
                                    cubit.showImagePicker(context);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0XFF2E4374),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userModel!.name.toString(),
                                style: const TextStyle(
                                    color: Color(0XFF2E4374), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {
                                    cubit.toggleEditing();
                                  },
                                  icon: const Icon(Icons.edit))
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          if (cubit.isEditing)
                            Column(
                              children: [
                                CutomTextField(
                                  controller: cubit.nameController,
                                  hintText: userModel!.name.toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Color(0XFF2E4374))),
                                  onPressed: cubit.saveChanges,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userModel!.phone.toString(),
                                style: const TextStyle(
                                    color: Color(0XFF2E4374), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {
                                    cubit.toggleEditingPhone();
                                  },
                                  icon: const Icon(Icons.edit))
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          if (cubit.isEditingPhone)
                            Column(
                              children: [
                                CutomTextField(
                                  controller: cubit.phoneController,
                                  hintText: userModel!.phone.toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Color(0XFF2E4374))),
                                  onPressed: cubit.saveChangesPhone,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                          PrimaryButton(
                            onTap: () {},
                            bgColor: const Color(0XFF2E4374),
                            text: "Logout",
                            textColor: Colors.white,
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.55,
                            borderRadius: 30,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
