import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scout/bloc/authentication/authentication_states.dart';
import 'package:uuid/uuid.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Account account;

  AuthenticationCubit(super.initialState, this.account);

  User? user;

  Future<void> checkLoggedIn() async {
    try {
      user = await account.get();
      Session session = await account.getSession(sessionId: 'current');
      emit(AuthenticatedState(user!, session));
    } catch (e) {
      emit(NoAuthenticatedState());
    }
  }

  Future<void> login(String number) async {
    try {
      var token = await account.createPhoneSession(
        phone: number,
        userId: const Uuid().v4(),
      );

      emit(OTPSentState(token.userId));
    } catch (e) {
      emit(AuthenticationFailedState(e.toString()));
    }
  }

  void verifyOTP(String otp, String uuid) async {
    try {
      Session session = await account.updatePhoneSession(
        userId: uuid,
        secret: otp,
      );

      user = await account.get();

      emit(AuthenticatedState(user!, session));
    } catch (e) {
      emit(AuthenticationFailedState(e.toString()));
    }
  }

  Future<void> logout() async {
    Session session = await account.getSession(sessionId: 'current');
    account.deleteSession(sessionId: session.$id);
    emit(NoAuthenticatedState());
  }
}
