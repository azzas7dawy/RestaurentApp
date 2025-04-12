part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {
  final String error;

  SignupFailed(this.error);
}

// login

final class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

final class LogoutState extends AuthState {}
final class LogoutLoading extends LogoutState {}
final class LogoutSuccess extends LogoutState {}
final class LogoutFailed extends LogoutState {
  final String error;

  LogoutFailed(this.error);
}

final class GoogleLoginState extends AuthState {}
final class GoogleLoginLoading extends GoogleLoginState {}
final class GoogleLoginSuccess extends GoogleLoginState {}
final class GoogleLoginFailed extends GoogleLoginState {
  final String error;

  GoogleLoginFailed(this.error);
}


final class ProfileUpdateState extends AuthState {}
final class ProfileUpdateLoading extends ProfileUpdateState {}
final class ProfileUpdateSuccess extends ProfileUpdateState {}
final class ProfileUpdateFailed extends ProfileUpdateState {
  final String error;
  ProfileUpdateFailed(this.error);
}


final class ResetPasswordState extends AuthState {}
final class ResetPasswordLoading extends ResetPasswordState {}
final class ResetPasswordSuccess extends ResetPasswordState {}
final class ResetPasswordFailed extends ResetPasswordState {
  final String error;
  ResetPasswordFailed(this.error);
}

final class DeleteAccountState extends AuthState {}
final class DeleteAccountLoading extends DeleteAccountState {}
final class DeleteAccountSuccess extends DeleteAccountState {}
final class DeleteAccountFailed extends DeleteAccountState {
  final String error;
  DeleteAccountFailed(this.error);
}

