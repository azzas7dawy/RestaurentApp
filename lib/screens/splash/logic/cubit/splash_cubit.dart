import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:restrant_app/services/pref_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initialize() async {
    try {
      await PrefService.init();
      await startAnimation();
      emit(SplashCubitAnimationComplete());
      await Future.delayed(const Duration(seconds: 3));
      if (PrefService.isLoggedIn) {
        emit(SplashCubitNavigateToHome());
      } else if (PrefService.isOnboardingSeen) {
        emit(SplashCubitNavigateToLogin());
      } else {
        emit(SplashCubitNavigateToOnboarding());
      }
    } catch (e) {
      emit(SplashCubitError(e.toString()));
    }
  }

  Future<void> startAnimation() async {
    const duration = Duration(seconds: 2);
    const steps = 100;
    final interval = duration.inMilliseconds ~/ steps;

    for (int i = 0; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: interval));
      emit(SplashCubitProgress(progress: i / steps));
    }
  }
}
