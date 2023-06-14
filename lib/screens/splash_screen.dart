import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/bloc/authentication/authentication_cubit.dart';
import 'package:scout/bloc/authentication/authentication_states.dart';
import 'package:scout/bloc/contracts/contracts_bloc.dart';
import 'package:scout/bloc/screenshot/screenshot_cubit.dart';
import 'package:scout/bloc/tracker/tracker_bloc.dart';
import 'package:scout/bloc/workdiary/workdiary_cubit.dart';
import 'package:scout/bloc/workdiary/workdiary_states.dart';
import 'package:scout/screens/auth_screen.dart';
import 'package:scout/screens/contracts_screen.dart';
import 'package:scout/screens/set_name_view.dart';
import 'package:scout/services/appwrite.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AuthenticationCubit authenticationCubit =
        GetIt.I.registerSingleton<AuthenticationCubit>(
      AuthenticationCubit(
          InitialAuthenticationState(), AppwriteService().account),
    );

    GetIt.I.registerSingleton<ContractBloc>(
      ContractBloc(appwriteService: AppwriteService()),
    );

    GetIt.I.registerSingleton<TrackerBloc>(
      TrackerBloc(AppwriteService()),
    );

    GetIt.I.registerSingleton<WorkDiaryCubit>(
      WorkDiaryCubit(
        WorkDiaryInitialState(),
        appwriteService: AppwriteService(),
      ),
    );

    GetIt.I.registerSingleton<ScreenshotCubit>(
      ScreenshotCubit(
        AppwriteService(),
      ),
    );

    authenticationCubit.checkLoggedIn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I.get<AuthenticationCubit>(),
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AuthenticatedState) {
            if (state.user.name == "") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const SetNameView(),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ContractsScreen(),
                ),
              );
            }
          }

          if (state is NoAuthenticatedState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AuthenticationScreen(),
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              "assets/logo.png",
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
        ),
      ),
    );
  }
}
