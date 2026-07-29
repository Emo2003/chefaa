import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chefaa/core/resources/assets_manager.dart';
import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/custom_btn.dart';
import 'package:chefaa/core/widgets/custom_text_field.dart';
import 'package:chefaa/core/widgets/loading.dart';
import 'package:chefaa/core/widgets/validators.dart';
import 'package:chefaa/features/auth/presentation/manager/auth_cubit.dart';
import 'package:chefaa/features/auth/presentation/widgets/custom_outline_btn.dart';
import 'package:chefaa/features/auth/presentation/widgets/not_have_account.dart';
import 'package:chefaa/features/auth/presentation/widgets/role_based_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final String? role;

  const LoginPage({super.key, this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late RoleNavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = RoleNavigationService(context);
  }

  void _showSuccessAndNavigate(dynamic user) {
    AnimatedSnackBar.rectangle(
      'Success',
      'Welcome back ${user.name}!',
      type: AnimatedSnackBarType.success,
      brightness: Brightness.dark,
      duration: const Duration(seconds: 3),
    ).show(context);

    _navigationService.toLayout(user.role!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p28,
                vertical: AppPadding.p80,
              ),
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) async {
                  if (state is LoginLoadingState ||
                      state is GoogleSignInLoadingState) {
                    Loading.show(context);
                  } else if (state is LoginErrorState) {
                    Loading.hide(context);
                    AnimatedSnackBar.rectangle(
                      'Error',
                      state.message,
                      type: AnimatedSnackBarType.error,
                      brightness: Brightness.dark,
                      duration: const Duration(seconds: 3),
                    ).show(context);
                  } else if (state is GoogleSignInErrorState) {
                    Loading.hide(context);
                    AnimatedSnackBar.rectangle(
                      'Error',
                      state.message ??
                          'An error occurred during Google sign-in',
                      type: AnimatedSnackBarType.error,
                      brightness: Brightness.dark,
                      duration: const Duration(seconds: 3),
                    ).show(context);
                  } else if (state is LoginSuccessState) {
                    Loading.hide(context);
                    _showSuccessAndNavigate(state.user);
                  } else if (state is GoogleSignInSuccessState) {
                    Loading.hide(context);
                    _showSuccessAndNavigate(state.user);
                  }
                },
                child: Builder(
                  builder: (context) {
                    final loginCubit = AuthCubit.get(context);
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Image.asset(
                              ImageAssets.loginLogo,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                          70.verticalSpace,
                          CustomTextField(
                            controller: loginCubit.identityController,
                            text: "Enter your Email or Phone",
                            prefixIcon: IconsAssets.emailIcon,
                          ),
                          20.verticalSpace,
                          CustomTextField(
                            controller: loginCubit.passwordController,
                            text: "Enter your Password",
                            prefixIcon: IconsAssets.passwordIcon,
                            validator: Validators.validateLoginPassword,
                            isPass: true,
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRoutesNames.forgetPassword);
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: ColorManager.primary,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorManager.primary,
                              ),
                            ),
                          ),
                          45.verticalSpace,
                          CustomBtn(
                            text: "Login",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginCubit.login();
                              }
                            },
                          ),
                          50.verticalSpace,
                          CustomOutlineBtn(
                            onPressed: () async {
                              debugPrint('Google sign-in button pressed');
                              try {
                                debugPrint(
                                  'Calling GoogleSignIn.instance.authenticate()',
                                );
                                final result = await GoogleSignIn.instance
                                    .authenticate();
                                debugPrint(
                                  'Google account selected: ${result.authentication}',
                                );
                                final String? idToken =
                                    result.authentication.idToken;
                                debugPrint('Google idToken: $idToken');

                                if (idToken != null) {
                                  if (context.mounted) {
                                    debugPrint(
                                      'Calling AuthCubit.signInWithGoogle()',
                                    );
                                    context.read<AuthCubit>().signInWithGoogle(
                                      idToken,
                                    );
                                  }
                                } else if (context.mounted) {
                                  debugPrint(
                                    'Google idToken is null, backend will not be called',
                                  );
                                  AnimatedSnackBar.rectangle(
                                    'Error',
                                    'Failed to retrieve Google ID token.',
                                    type: AnimatedSnackBarType.error,
                                    brightness: Brightness.dark,
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                }
                              } catch (e) {
                                debugPrint('Google sign-in exception: $e');
                                if (context.mounted &&
                                    (e is! Exception ||
                                        !e.toString().contains('cancel'))) {
                                  AnimatedSnackBar.rectangle(
                                    'Error',
                                    e.toString(),
                                    type: AnimatedSnackBarType.error,
                                    brightness: Brightness.dark,
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                }
                              }
                            },
                            prefixImage: SvgAssets.google,
                            title: "Sign in with Google",
                          ),
                          20.verticalSpace,
                          NotHaveAccount(
                            onPressed: () {
                              _navigationService.toSignUp(widget.role);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
