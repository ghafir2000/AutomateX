
import 'package:app/Controller/Check_Acount.dart';
import 'package:app/View/Inc_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Create_Account_Page.dart';

final CheckAccount controllercheck = Get.put(CheckAccount());

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            shadowColor: Colors.blueAccent,
            centerTitle: true,
            title: const Column(
              children: [
                Text("Egg Incubator"),
              ],
            ),
          ),
          bottomNavigationBar:
          const Icon(Icons.home_filled),

          body:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                width: Get.width,
                height: Get.height*0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/ff.png'))
                ),

              ),
              SizedBox(height: Sizebetween,),
              Container(
                decoration:const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.elliptical(5, 5))
                ),
                width: Get.width*0.8,
                height: Get.height*0.05,
                child: TextField(
                  onChanged: (value) => controllercheck.username(value),
                  decoration:const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                      label: Text("User Name"),
                      hintText: "Ahmad , Majed , eg",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(5, 5),
                          )
                      )
                  ),
                ),
              ),
              SizedBox(height: Sizebetween,),
              Container(
                decoration:const BoxDecoration(
                    backgroundBlendMode: BlendMode.darken,
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.elliptical(5, 5))
                ),
                width: Get.width*0.8,
                height: Get.height*0.05,
                child: Builder(
                    builder: (context) {
                      return Obx(() => TextField(
                        onChanged: (value) => controllercheck.password(value),
                        obscureText: controllercheck.obscureText.value,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                            labelText: AutofillHints.password,
                            hintText: "******",
                            border:const  OutlineInputBorder(
                                borderSide: BorderSide(
                                ),
                                borderRadius: BorderRadius.all(

                                  Radius.elliptical(5, 5),
                                )
                            ),
                            suffixIcon: IconButton(
                              iconSize: 18,
                              icon: Icon(
                                color: Colors.black,
                                controllercheck.obscureText.value ? Icons.visibility : Icons.visibility_off,),
                              onPressed:  controllercheck.toggleVisibility,
                            )
                        ),
                      ));
                    }
                ),
              ),
              SizedBox(height: Sizebetween,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(const CreateAccountPage());
                    },
                    child: Container(
                      width: Get.width*0.3,
                      height: Get.height*0.04,
                      decoration:const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                        color: Colors.blueAccent,
                      ) ,
                      child:const Center(child:Text("Create Account",style: TextStyle(color: Colors.white,),)),
                    ),
                  ),
                  SizedBox(width: Get.width*0.09,),
                  GestureDetector(
                    onTap: () async {
                      if(await controllercheck.login()){
                        Get.to(() => const Inc_Page());
                      }
                      else{Get.snackbar('error', 'wrong');}
                    },
                    child: Container(
                      width: Get.width*0.2,
                      height: Get.height*0.04,
                      decoration:const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                        color: Colors.blueAccent,
                      ) ,
                      child:const Center(child:Text("Login",style: TextStyle(color: Colors.white,),)),
                    ),
                  ),
                ],
              )
            ],
          ),
    ))
    ;
  }
}
