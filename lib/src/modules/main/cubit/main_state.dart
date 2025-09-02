part of 'main_cubit.dart';

class MainState extends Equatable {
  final bool isDarkMode;
  const MainState({required this.isDarkMode});
  @override
  List<Object?> get props => [isDarkMode];
}
