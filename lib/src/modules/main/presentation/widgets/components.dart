import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/images_manager.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/main/cubit/main_cubit.dart';
import 'package:quran_station/src/modules/main/presentation/ui_entities/main_screen_item.dart';
import 'package:quran_station/src/modules/quiz/presentation/screens/start_quiz_screen.dart';
import 'package:quran_station/src/modules/reading/presentation/screens/moshaf_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

Widget appDrawer(BuildContext context) {
  final theme = Theme.of(context);

  return Drawer(
    child: Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header - simplified design without heavy gradient
          Container(
            height: 25.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.w),
                bottomRight: Radius.circular(4.w),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 4.h,
                  backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                  backgroundImage: AssetImage(ImagesManager.logo),
                ),
                SizedBox(height: 1.h),
                Text(
                  "كلام ربي",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const HeightSeparator(),
          Expanded(
              child: ListView(
            children: [
              _buildSectionTitle(context, "الأقسام"),
              _buildModernListTile(
                context,
                icon: Icons.menu_book_rounded,
                title: "المصحف",
                onTap: () {
                  Navigator.pop(context);
                  context.push(const MoshafScreen());
                },
              ),
              _buildModernListTile(
                context,
                icon: Icons.quiz_outlined,
                title: "اختبر نفسك",
                onTap: () {
                  Navigator.pop(context);
                  context.push(const StartQuizScreen());
                },
              ),
              const HeightSeparator(),
              _buildSectionTitle(context, "الإعدادات"),
              BlocBuilder<MainCubit, MainState>(
                builder: (context, state) {
                  return _buildModernListTile(
                    context,
                    icon: state.isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    title: state.isDarkMode ? "الوضع الفاتح" : "الوضع الداكن",
                    onTap: () {
                      context
                          .read<MainCubit>()
                          .changeTheme(!state.isDarkMode);
                    },
                    trailing: Switch(
                      value: state.isDarkMode,
                      onChanged: (value) {
                        context.read<MainCubit>().changeTheme(value);
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
              const HeightSeparator(),
              _buildSectionTitle(context, "التطبيق"),
              _buildModernListTile(
                context,
                icon: Icons.share_outlined,
                title: "مشاركة التطبيق",
                onTap: () {
                  Share.share(
                    "استمتع بتجربة قرآنية مميزة مع تطبيق كلام ربي \n https://play.google.com/store/apps/details?id=com.zerobugs.kalamrabbi",
                  );
                },
              ),
              _buildModernListTile(
                context,
                icon: Icons.email_outlined,
                title: "تواصل معنا",
                onTap: () async {
                  if (!await launchUrl(
                      Uri.parse("mailto:mahmoud.atef.work@gmail.com"))) {
                    throw Exception('Could not launch');
                  }
                },
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(2.w),
                child: Text(
                  "نسألكم الدعاء بظهر الغيب",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ))
        ],
      ),
    ),
  );
}

Widget _buildSectionTitle(BuildContext context, String title) {
  final theme = Theme.of(context);
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    ),
  );
}

Widget _buildModernListTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Widget? trailing,
}) {
  final theme = Theme.of(context);
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(3.w),
      border: Border.all(
        color: theme.colorScheme.outline.withOpacity(0.1),
        width: 1,
      ),
    ),
    child: ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            size: 4.w,
          ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
    ),
  );
}

class HeightSeparator extends StatelessWidget {
  final double? height;
  const HeightSeparator({super.key, this.height});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? 2.h);
  }
}

class DefaultButton extends StatelessWidget {
  final void Function() onPressed;
  final double? height;
  final double? width;
  final String title;
  final bool isSecondary;
  final bool isOutlined;
  final IconData? icon;

  const DefaultButton({
    super.key,
    required this.onPressed,
    this.height,
    this.width,
    required this.title,
    this.isSecondary = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? 7.h,
      width: width ?? 50.w,
      decoration: BoxDecoration(
        color: !isOutlined
            ? (isSecondary ? theme.colorScheme.secondary : theme.colorScheme.primary)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(25.sp),
        border: isOutlined
            ? Border.all(
                color: isSecondary
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25.sp),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isOutlined
                        ? (isSecondary
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primary)
                        : theme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                ],
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isOutlined
                        ? (isSecondary
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primary)
                        : theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreenItemWidget extends StatelessWidget {
  final MainScreenItem item;
  const MainScreenItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.push(item.screen);
      },
      child: Container(
        height: item.height?.h ?? 15.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.icon,
            const HeightSeparator(),
            Text(
              item.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DefaultTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? labelText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? readOnly;
  final bool? enabled;
  const DefaultTextFeild(
      {super.key,
      required this.controller,
      this.hintText,
      this.keyboardType,
      this.obscureText,
      this.labelText,
      this.onChanged,
      this.onTap,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.prefixIcon,
      this.readOnly,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      onTap: onTap,
      onSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        fillColor: theme.colorScheme.surface,
        filled: true,
      ),
      readOnly: readOnly ?? false,
      enabled: enabled ?? true,
    );
  }
}
