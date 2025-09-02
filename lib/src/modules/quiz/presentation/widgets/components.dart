import 'package:flutter/material.dart';
import 'package:quran_station/src/modules/quiz/cubit/quiz_cubit.dart';
import 'package:quran_station/src/modules/quiz/data/models/questoin.dart';
import 'package:sizer/sizer.dart';

class ProgressBar extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Duration? animationDuration;

  const ProgressBar({
    super.key,
    required this.currentQuestion,
    this.totalQuestions = 20,
    this.animationDuration,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0; // متغير لحفظ القيمة السابقة

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    _updateProgress();
  }

  void _updateProgress() {
    final currentProgress = widget.currentQuestion / widget.totalQuestions;

    _progressAnimation = Tween<double>(
      begin: _previousProgress, // البداية من آخر قيمة بدلاً من 0
      end: currentProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    ));

    _animationController.reset();
    _animationController.forward();

    // تحديث القيمة السابقة
    _previousProgress = currentProgress;
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestion != widget.currentQuestion) {
      _updateProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        children: [
          // Progress label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${widget.currentQuestion} من ${widget.totalQuestions}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1),
                      const Color(0xFF8B5CF6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${((widget.currentQuestion / widget.totalQuestions) * 100).toInt()}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Modern progress bar with gradient
          Container(
            height: 1.8.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D3748) : const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(2.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Background
                    Container(
                      height: 1.8.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2D3748)
                            : const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),

                    // Progress with beautiful gradient
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 1.8.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                              Color(0xFFF093FB),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(2.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Animated shine effect
                    if (_progressAnimation.value > 0)
                      Positioned(
                        right: 0,
                        child: FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            height: 1.8.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionNumber;

  const QuestionCard({
    super.key,
    required this.question,
    this.questionNumber = 1,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _optionController;
  late Animation<double> _cardAnimation;
  late Animation<double> _optionAnimation;

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _optionController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    );

    _optionAnimation = CurvedAnimation(
      parent: _optionController,
      curve: Curves.easeOutBack,
    );

    _cardController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _optionController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        width: 90.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Question card with modern design
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF2D3748),
                            const Color(0xFF1A202C),
                          ]
                        : [
                            Colors.white,
                            const Color(0xFFF8FAFC),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.1)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF4A5568).withOpacity(0.3)
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative background elements
                    Positioned(
                      top: -3.h,
                      right: -6.w,
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question header with modern style
                          Row(
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF667EEA)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.questionNumber}',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'السؤال ${widget.questionNumber}',
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      'اختر الإجابة الصحيحة',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.w),

                          // Question text with enhanced styling
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFF4A5568)
                                            .withOpacity(0.3),
                                        const Color(0xFF2D3748)
                                            .withOpacity(0.5),
                                      ]
                                    : [
                                        const Color(0xFFF0F9FF),
                                        const Color(0xFFE0F2FE),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(
                                color: const Color(0xFF67E8F9).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              widget.question.questionText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.8,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Options with staggered animation
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.8),
                  end: Offset.zero,
                ).animate(_optionAnimation),
                child: FadeTransition(
                  opacity: _optionAnimation,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _buildOption(context, index),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 2.5.h),
                    itemCount: widget.question.answers.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index) {
    final theme = Theme.of(context);
    final cubit = QuizCubit.get();
    final isSelected = widget.question.userAnswer == index;
    final isCompleted = cubit.quizCompleted;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: _getOptionShadowColor(isDark, index, isCompleted),
            blurRadius: isSelected ? 20 : 12,
            offset: Offset(0, isSelected ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCompleted
              ? null
              : () => cubit.answerQuestion(widget.question, index),
          borderRadius: BorderRadius.circular(4.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: _getOptionGradient(theme, index, isCompleted, isDark),
              borderRadius: BorderRadius.circular(4.w),
              border: Border.all(
                color: _getOptionBorderColor(theme, index, isCompleted),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Option indicator with enhanced design
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      gradient: _getIndicatorGradient(
                          theme, index, isCompleted, isDark),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _getIndicatorBorderColor(theme, index, isCompleted),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getIndicatorShadowColor(index, isCompleted)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _getOptionIcon(theme, index, isCompleted) ??
                          Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  // Answer text with better typography
                  Expanded(
                    child: Text(
                      widget.question.answers[index],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _getOptionTextColor(
                            theme, index, isCompleted, isDark),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        height: 1.5,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),

                  // Enhanced selection indicator
                  if (isSelected && !isCompleted)
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF667EEA),
                            Color(0xFF764BA2),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced color methods with modern gradients
  LinearGradient _getOptionGradient(
      ThemeData theme, int index, bool isCompleted, bool isDark) {
    if (!isCompleted) {
      if (widget.question.userAnswer == index) {
        return LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.15),
            const Color(0xFF764BA2).withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
      return LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF2D3748),
                const Color(0xFF1A202C),
              ]
            : [
                Colors.white,
                const Color(0xFFFAFBFC),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const LinearGradient(
          colors: [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFDC2626),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
      return LinearGradient(
        colors: isDark
            ? [
                const Color(0xFF374151),
                const Color(0xFF1F2937),
              ]
            : [
                const Color(0xFFF9FAFB),
                const Color(0xFFF3F4F6),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Color _getOptionBorderColor(ThemeData theme, int index, bool isCompleted) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const Color(0xFF667EEA)
          : const Color(0xFFE5E7EB);
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const Color(0xFF10B981);
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const Color(0xFFEF4444);
      }
      return const Color(0xFFE5E7EB);
    }
  }

  LinearGradient _getIndicatorGradient(
      ThemeData theme, int index, bool isCompleted, bool isDark) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)])
          : LinearGradient(colors: [
              isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
              isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
            ]);
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)]);
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)]);
      }
      return LinearGradient(colors: [
        isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
        isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
      ]);
    }
  }

  Color _getIndicatorBorderColor(ThemeData theme, int index, bool isCompleted) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const Color(0xFF4338CA)
          : const Color(0xFFD1D5DB);
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const Color(0xFF047857);
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const Color(0xFFB91C1C);
      }
      return const Color(0xFFD1D5DB);
    }
  }

  Color _getIndicatorShadowColor(int index, bool isCompleted) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const Color(0xFF667EEA)
          : const Color(0xFF9CA3AF);
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const Color(0xFF10B981);
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const Color(0xFFEF4444);
      }
      return const Color(0xFF9CA3AF);
    }
  }

  Color _getOptionShadowColor(bool isDark, int index, bool isCompleted) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const Color(0xFF667EEA).withOpacity(0.2)
          : Colors.black.withOpacity(isDark ? 0.3 : 0.08);
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return const Color(0xFF10B981).withOpacity(0.2);
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const Color(0xFFEF4444).withOpacity(0.2);
      }
      return Colors.black.withOpacity(isDark ? 0.2 : 0.06);
    }
  }

  Color _getOptionTextColor(
      ThemeData theme, int index, bool isCompleted, bool isDark) {
    if (!isCompleted) {
      return widget.question.userAnswer == index
          ? const Color(0xFF1E40AF)
          : (isDark ? Colors.white : const Color(0xFF1F2937));
    } else {
      if (widget.question.trueAnswerIndex == index) {
        return Colors.white;
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return Colors.white;
      }
      return isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);
    }
  }

  Widget? _getOptionIcon(ThemeData theme, int index, bool isCompleted) {
    if (isCompleted) {
      if (widget.question.trueAnswerIndex == index) {
        return const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 24,
        );
      } else if (widget.question.userAnswer == index &&
          widget.question.getMark() == 0) {
        return const Icon(
          Icons.cancel,
          color: Colors.white,
          size: 24,
        );
      }
    }
    return null;
  }

  @override
  void dispose() {
    _cardController.dispose();
    _optionController.dispose();
    super.dispose();
  }
}
