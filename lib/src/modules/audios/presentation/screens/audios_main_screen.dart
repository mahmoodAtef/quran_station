// lib/src/modules/audios/presentation/screens/audios_main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/search_for_reciter_screen.dart';
import 'package:quran_station/src/modules/audios/presentation/widgets/tab_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../main/presentation/widgets/components.dart';
import '../../bloc/audios_bloc.dart';
import '../widgets/components.dart';

class AudiosMainScreen extends StatelessWidget {
  const AudiosMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final bloc = AudiosBloc.get();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: appDrawer(context),
      appBar: _buildAppBar(context, theme, scaffoldKey),
      body: BlocListener<AudiosBloc, AudiosState>(
        bloc: bloc,
        listener: (context, state) {
          _handleExceptions(context, state);
          if (state is GetAllRecitersSuccessState) {
            bloc.add(GetFavoriteRecitersEvent());
          }
        },
        child: Container(
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              _buildTabsSection(theme, bloc),
              _buildContentSection(theme, bloc),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      ThemeData theme,
      GlobalKey<ScaffoldState> scaffoldKey,
      ) {
    return AppBar(
      leadingWidth: 10.w,
      leading: IconButton(
        onPressed: () => scaffoldKey.currentState!.openDrawer(),
        icon: Icon(
          Icons.menu_rounded,
          color: theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface,
        ),
        tooltip: 'القائمة',
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        highlightColor: theme.colorScheme.primary.withOpacity(0.1),
      ),
      centerTitle: true,
      title: Text(
        'الصوتيات',
        style: theme.appBarTheme.titleTextStyle ??
            theme.textTheme.titleLarge?.copyWith(
              color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(const SearchForReciterScreen()),
          icon: Icon(
            Icons.search_rounded,
            color: theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface,
          ),
          tooltip: 'البحث',
          splashColor: theme.colorScheme.primary.withOpacity(0.2),
          highlightColor: theme.colorScheme.primary.withOpacity(0.1),
        ),
        SizedBox(width: 1.w),
      ],
    );
  }

  Widget _buildTabsSection(ThemeData theme, AudiosBloc bloc) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 6.h,
        width: 90.w,
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => bloc.add(ChangeTabEvent(index)),
                  borderRadius: BorderRadius.circular(10),
                  splashColor: theme.colorScheme.primary.withOpacity(0.2),
                  highlightColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: TabWidget(index: index),
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemCount: bloc.tabs.length,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme, AudiosBloc bloc) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(bloc.currentTab),
                child: bloc.audioTabsWidgets[bloc.currentTab],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleExceptions(BuildContext context, AudiosState state) {
    final theme = Theme.of(context);

    if (state is AudiosError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(

            'حدث خطأ أثناء تحميل البيانات',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'موافق',
            textColor: theme.colorScheme.onError,
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );

      ExceptionHandler.handle(state.exception);
      Navigator.pop(context);
    }
  }
}