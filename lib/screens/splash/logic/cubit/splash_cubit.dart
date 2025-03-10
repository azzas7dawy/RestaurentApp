import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  void initialize() async {
    await startAnimation();
    emit(SplashCubitAnimationComplete());
    await Future.delayed(const Duration(seconds: 3));
    emit(SplashCubitNavigateToHome());
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
