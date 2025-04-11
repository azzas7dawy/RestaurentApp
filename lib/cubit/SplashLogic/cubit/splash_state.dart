part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashCubitProgress extends SplashState {
  final double progress;

  SplashCubitProgress({required this.progress});
}

final class SplashCubitAnimationComplete extends SplashState {}

final class SplashCubitNavigateToHome extends SplashState {}

final class SplashCubitNavigateToLogin extends SplashState {}

final class SplashCubitNavigateToOnboarding extends SplashState {}

final class SplashCubitError extends SplashState {
  final String message;

  SplashCubitError(this.message);
}
