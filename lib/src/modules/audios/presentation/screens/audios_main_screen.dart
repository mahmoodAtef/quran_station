import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/exceptions/exception_handler.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/search_for_reciter_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../main/presentation/widgets/components.dart';
import '../../bloc/audios_bloc.dart';
import '../widgets/components.dart';

class AudiosMainScreen extends StatelessWidget {
  const AudiosMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    AudiosBloc bloc = AudiosBloc.get();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: appDrawer(context),
      appBar: AppBar(
        leadingWidth: 10.w,
        leading: IconButton(
          onPressed: () async {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
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
                color: theme.appBarTheme.foregroundColor ??
                    theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(const SearchForReciterScreen());
            },
            icon: Icon(
              Icons.search,
            ),
            tooltip: 'البحث',
          ),
        ],
      ),
      body: BlocListener<AudiosBloc, AudiosState>(
        bloc: bloc,
        listener: (context, state) {
          _handleExceptionS(context, state);
          if (state is GetAllRecitersSuccessState) {
            bloc.add(GetFavoriteRecitersEvent());
          }
        },
        child: BlocBuilder<AudiosBloc, AudiosState>(
          bloc: bloc,
          builder: (context, state) {
            return Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  // Tabs Section
                  Container(
                    margin: EdgeInsets.all(4.0.w),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 6.h,
                      width: 90.w,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        itemBuilder: (context, index) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              bloc.add(ChangeTabEvent(index));
                            },
                            borderRadius: BorderRadius.circular(8.0),
                            splashColor:
                                theme.colorScheme.primary.withOpacity(0.2),
                            highlightColor:
                                theme.colorScheme.primary.withOpacity(0.1),
                            child: TabWidget(
                              index: index,
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 2.0.w,
                        ),
                        itemCount: bloc.tabs.length,
                      ),
                    ),
                  ),

                  // Content Section
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.08),
                            blurRadius: 10.0,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: BlocBuilder<AudiosBloc, AudiosState>(
                        bloc: bloc,
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              key: ValueKey(bloc.currentTab),
                              child: bloc.audioTabsWidgets[bloc.currentTab],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleExceptionS(BuildContext context, AudiosState state) {
    final theme = Theme.of(context);

    if (state is AudiosError) {
      // Show error message with theme colors before handling exception
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
          action: SnackBarAction(
            label: 'موافق',
            textColor: theme.colorScheme.onError,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      ExceptionHandler.handle(state.exception);
      Navigator.pop(context);
    }
  }
}
