import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/cubit/social_cubit.dart';

import '../components/default_text_field.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../helpers/cache.dart';
import 'home.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginErrorState)
          _showSnakBar(context, 'An error occurred', Colors.redAccent);
        if (state is LoginSuccessState) {
          _showSnakBar(context, 'Login Successfully', Colors.greenAccent);

          CacheHelper.saveData('token', state.userItem.uid).then((value) {
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getPosts();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          });
        }
        if (state is CreateUserSuccessState) {
          _showSnakBar(context, 'User Created', Colors.greenAccent);

          CacheHelper.saveData('token', state.userData.uid).then((value) {
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getPosts();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          });
        }
        if (state is LoginFirebaseAuthExceptionState)
          _showSnakBar(context, state.error, Colors.redAccent);
      },
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.isLogin ? 'LOGIN' : 'REGISTER',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        cubit.isLogin
                            ? 'Login now to communicate with your friends and family'
                            : 'Register now to enjoy the full features of the app',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: const SizedBox(height: 20),
                        crossFadeState: cubit.isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: DefaultTextField(
                          label: 'User Name',
                          key: const ValueKey('name'),
                          type: TextInputType.name,
                          controller: nameController,
                          prefix: Icons.person,
                          validate: (String? value) {
                            if (!cubit.isLogin && value!.isEmpty) {
                              return 'Please enter your name';
                            } else if (!cubit.isLogin && value!.length < 3) {
                              return 'User name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        crossFadeState: cubit.isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(height: 20),
                      DefaultTextField(
                        label: 'Email Address',
                        key: const ValueKey('email'),
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        prefix: Icons.email_outlined,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: const SizedBox(height: 20),
                        crossFadeState: cubit.isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox(),
                        secondChild: DefaultTextField(
                          label: 'Phone Number',
                          key: const ValueKey('phone'),
                          type: TextInputType.phone,
                          controller: phoneController,
                          prefix: Icons.phone,
                          validate: (String? value) {
                            if (!cubit.isLogin && value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!cubit.isLogin && value!.length != 11) {
                              return 'Phone number must be 11 characters';
                            }
                            return null;
                          },
                        ),
                        crossFadeState: cubit.isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(height: 20),
                      DefaultTextField(
                        label: 'Password',
                        key: const ValueKey('password'),
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        isPassword: !cubit.isPasswordShown,
                        suffixPress: cubit.changeVisibility,
                        prefix: Icons.lock_outline,
                        suffix: cubit.isPasswordShown
                            ? Icons.visibility_off
                            : Icons.visibility,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      state is! LoginLoadingState
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  FocusScope.of(context).unfocus();
                                  cubit.loginOrRegister(
                                    type: cubit.isLogin ? 'login' : 'register',
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              child: Text(
                                cubit.isLogin ? 'LOGIN' : 'REGISTER',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            cubit.isLogin
                                ? 'Create new account'
                                : 'Already have an account?',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: cubit.toggleCase,
                            child: Text(
                              cubit.isLogin ? 'REGISTER' : 'LOGIN',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }

  void _showSnakBar(ctx, String message, redAccent) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 20,
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: redAccent,
      ),
    );
  }
}
