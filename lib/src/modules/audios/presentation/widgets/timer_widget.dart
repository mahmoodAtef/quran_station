import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_station/src/modules/audios/bloc/audios_bloc.dart';
import 'package:sizer/sizer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int? selectedMinutes;
  AudiosBloc bloc = AudiosBloc.get();

  void _showTimerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 50.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('حدد مدة المؤقت'),
              const SizedBox(height: 16.0),
              BlocBuilder<AudiosBloc, AudiosState>(
                builder: (context, state) {
                  return LinearProgressIndicator(
                    value: bloc.playbackTimerPercentage ?? 0.0,
                  );
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: ListView(
                  children: [5, 10, 20, 30, 45, 60, 90].map((int value) {
                    return ListTile(
                      title: Text('$value دقائق'),
                      onTap: () {
                        Navigator.pop(context);
                        bloc.add(SetPlaybackTimerEvent(value));
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudiosBloc, AudiosState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
                child: Center(
              child: CircularProgressIndicator(
                value: bloc.playbackTimerPercentage ?? 0.0,
              ),
            )),
            Center(
              child: IconButton(
                icon: const Icon(Icons.timer),
                onPressed: () => _showTimerBottomSheet(context),
              ),
            )
          ],
        );
      },
    );
  }
}
