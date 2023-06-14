import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scout/bloc/authentication/authentication_states.dart';
import 'package:scout/widgets/custom_form_field.dart';

import '../bloc/authentication/authentication_cubit.dart';
import 'contracts_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  final RoundedLoadingButtonController _roundedLoadingButtonController =
      RoundedLoadingButtonController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            "assets/logo.png",
            scale: 5,
          ),
          const Text(
            "Log In",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          BlocConsumer<AuthenticationCubit, AuthenticationState>(
              bloc: GetIt.I.get<AuthenticationCubit>(),
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) {
                if (state is AuthenticatedState) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const ContractsScreen(),
                    ),
                  );
                }
              },
              builder: (BuildContext context, AuthenticationState state) {
                if (state is OTPSentState) {
                  _roundedLoadingButtonController.stop();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomFormField(
                          help: 'OTP',
                          child: TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      RoundedLoadingButton(
                        controller: _roundedLoadingButtonController,
                        onPressed: () {
                          GetIt.I.get<AuthenticationCubit>().verifyOTP(
                                _otpController.text,
                                state.uuid,
                              );
                        },
                        color: Colors.redAccent,
                        child: const Text(
                          "Verify",
                        ),
                      ),
                    ],
                  );
                } else if (state is AuthenticationFailedState) {
                  _roundedLoadingButtonController.error();
                  Future.delayed(const Duration(seconds: 2), () {
                    _roundedLoadingButtonController.reset();
                  });
                } else if (state is AuthenticatedState) {
                  _roundedLoadingButtonController.success();
                  Future.delayed(const Duration(milliseconds: 500), () {});
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomFormField(
                        help: 'Phone',
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: "+9779800000000",
                          ),
                        ),
                      ),
                    ),
                    RoundedLoadingButton(
                      controller: _roundedLoadingButtonController,
                      onPressed: () {
                        GetIt.I.get<AuthenticationCubit>().login(
                              _phoneController.text,
                            );
                      },
                      color: Colors.redAccent,
                      child: const Text(
                        "Get In",
                      ),
                    ),
                  ],
                );
              }),
          Text(
            "Version: 1.0.0",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
