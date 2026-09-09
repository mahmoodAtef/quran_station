// lib/src/modules/audios/presentation/widgets/reciter_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/core/utils/navigation_manager.dart';
import 'package:quran_station/src/modules/audios/presentation/screens/reciter_screen.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/audios_bloc.dart';
import '../../data/models/reciter/reciter_model.dart';

class ReciterItem extends StatelessWidget {
  final Reciter reciter;

  const ReciterItem({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bloc = AudiosBloc.get();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: InkWell(
          onTap: () => context.push(ReciterScreen(reciterID: reciter.data.id)),
          borderRadius: BorderRadius.circular(3.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: colorScheme.surface,
            ),
            child: Row(
              children: [
                _Avatar(colorScheme: colorScheme),
                SizedBox(width: 3.w),
                Expanded(
                  child: _Details(theme: theme, colorScheme: colorScheme, reciter: reciter),
                ),
                _FavoriteButton(bloc: bloc, colorScheme: colorScheme, reciter: reciter),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ColorScheme colorScheme;

  const _Avatar({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Icon(Icons.person, color: colorScheme.primary, size: 6.w),
    );
  }
}

class _Details extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final Reciter reciter;

  const _Details({
    required this.theme,
    required this.colorScheme,
    required this.reciter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reciter.data.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.2.h),
        Row(
          children: [
            Icon(Icons.library_books_outlined,
                size: 3.6.w, color: colorScheme.onSurface.withOpacity(0.6)),
            SizedBox(width: 1.w),
            Text(
              '${reciter.data.rewayasCount} قراءة',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            SizedBox(width: 3.w),
            Icon(Icons.audiotrack,
                size: 3.6.w, color: colorScheme.onSurface.withOpacity(0.6)),
            SizedBox(width: 1.w),
            Text(
              '${reciter.data.surahsCount} تسجيل',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final AudiosBloc bloc;
  final ColorScheme colorScheme;
  final Reciter reciter;

  const _FavoriteButton({
    required this.bloc,
    required this.colorScheme,
    required this.reciter,
  });


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudiosBloc, AudiosState>(
      bloc: bloc,
      builder: (context, state) {
        final isFavorite = bloc.favoriteReciters.contains(reciter);
        return Container(
          width: 9.w,
          height: 9.w,
          decoration: BoxDecoration(
            color: isFavorite
                ? colorScheme.primary.withOpacity(0.1)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(4.5.w),
            border: Border.all(
              color: isFavorite
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (isFavorite) {
                bloc.add(RemoveReciterFromFavoritesEvent(reciter.data.id));
              } else {
                bloc.add(AddReciterToFavoritesEvent(reciter.data.id));
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.6),
              size: 4.5.w,
            ),
          ),
        );
      },
    );
  }
}
