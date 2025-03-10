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
