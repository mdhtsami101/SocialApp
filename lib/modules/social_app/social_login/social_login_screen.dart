
import 'package:ayhaga/layout/social_app/social_layout.dart';
import 'package:ayhaga/modules/social_app/social_login/cubit/cubit.dart';
import 'package:ayhaga/modules/social_app/social_login/cubit/states.dart';
import 'package:ayhaga/modules/social_app/social_register/social_register_screen.dart';
import 'package:ayhaga/shared/components/components.dart';
import 'package:ayhaga/shared/network/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginScreen extends StatelessWidget {

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if(state is SocialLoginErrorState){
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState){
            CacheHelper.saveData(
                key: "uId",
                value:state.uId
            ).then((value) {
              navigateAndFinish(context,SocialLayout());
            });

          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Login now to communicat with friends',
                          style:Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey ,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validat: ( String? value){
                            if(value!.isEmpty){
                              return 'please enter your email address' ;
                            }
                          },
                          lable: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validat: ( String? value){
                            if(value!.isEmpty){
                              return 'password is to short' ;
                            }
                          },
                          lable: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: SocialLoginCubit.get(context).suffix,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffixPressed: (){
                            SocialLoginCubit.get(context).changePasswordVisibility();
                          } ,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition:state is! SocialLoginLoadingState ,
                          builder:(context) => defaultButton(
                              Function: (){
                                if(formkey.currentState!.validate())
                                {
                                  SocialLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                                  print(emailController.text);
                                  print(passwordController.text);

                                }
                              },
                              text: 'LOGIN' ,
                              isUpperCase: true
                          ),
                          fallback:(context) => Center(child: CircularProgressIndicator()) ,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account ?',
                            ),
                            defaultTextButton(
                              Function: (){
                                navigateTo(context, SocialRegisterScreen());
                              },
                              text: 'register now',
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}
