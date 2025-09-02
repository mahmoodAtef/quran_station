import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:quran_station/src/core/utils/theme_manager.dart';

part 'main_state.dart';

class MainCubit extends HydratedCubit<MainState> {
  static MainCubit? instance;
  static MainCubit get() {
    instance ??= MainCubit();

    return instance!;
  }

  MainCubit() : super(const MainState(isDarkMode: false));
  void changeTheme(bool isDarkMode) {
    AppTheme.setTheme(isDarkMode);
    emit(MainState(isDarkMode: isDarkMode));
  }

  @override
  MainState? fromJson(Map<String, dynamic> json) {
    AppTheme.setTheme(json['isDarkMode']);
    return MainState(isDarkMode: json['isDarkMode']);
  }

  @override
  Map<String, dynamic>? toJson(MainState state) {
    return {'isDarkMode': state.isDarkMode};
  }
}
