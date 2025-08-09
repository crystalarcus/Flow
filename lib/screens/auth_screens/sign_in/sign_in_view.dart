import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/auth_screens/sign_in/sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Flow",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  "A Social Media App",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: context.read<SignInViewModel>().emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller:
                      context.read<SignInViewModel>().passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap:
                        context.read<SignInViewModel>().onForgetPasswordPress,
                    child: const Text("Forget password"),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: context.read<SignInViewModel>().onLoginPress,
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(height: 56),
                const Text("Don't have an account ?"),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: context.read<SignInViewModel>().onSignUpPress,
                    child: const Text("Sign up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
