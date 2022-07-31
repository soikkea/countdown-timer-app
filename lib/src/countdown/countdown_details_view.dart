import 'dart:async';
import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountdownTimerDetailsArguments {
  final int id;

  CountdownTimerDetailsArguments(this.id);
}

class CountdownTimerDetailsView extends StatelessWidget {
  const CountdownTimerDetailsView({Key? key}) : super(key: key);

  static const routeName = '/countdown_timer';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as CountdownTimerDetailsArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<CountdownTimerProvider>(context, listen: false)
                  .deleteCountdownTimer(args.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(child: CountdownTimerDetails(id: args.id)),
    );
  }
}

class CountdownTimerDetails extends StatefulWidget {
  const CountdownTimerDetails({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<CountdownTimerDetails> createState() => _CountdownTimerDetailsState();
}

class _CountdownTimerDetailsState extends State<CountdownTimerDetails> {
  late Future<CountdownTimer> countdownTimer;
  DateTime _currentTimeLocal = DateTime.now();
  late Timer _timer;

  static const updateRate = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    countdownTimer = Provider.of<CountdownTimerProvider>(context, listen: false)
        .getCountdownTimer(widget.id);
    _timer = Timer.periodic(updateRate, (timer) {
      setState(() {
        _currentTimeLocal = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String padNumber(int number) {
    return number.toString().padLeft(2, "0");
  }

  String _formatTarget(DateTime targetInUtc) {
    return DateFormat("yyyy-MM-dd HH:mm").format(targetInUtc.toLocal());
  }

  String _formatDurationToTarget(DateTime targetInUtc) {
    // TODO: Handle case when duration negative
    final targetInLocal = targetInUtc.toLocal();
    final duration = targetInLocal.isAfter(_currentTimeLocal)
        ? targetInLocal.difference(_currentTimeLocal)
        : _currentTimeLocal.difference(targetInLocal);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    int millis = ((duration.inMilliseconds % 1000) / 100).round();
    millis = millis == 10 ? 0 : millis;
    return '${days.toString()} d, ${padNumber(hours)}:${padNumber(minutes)}:${padNumber(seconds)}.${millis.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<CountdownTimer>(
      future: countdownTimer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO: show more info
          return Column(
            children: [
              Text(snapshot.data!.name,
                  style: Theme.of(context).textTheme.headline3),
              Text(
                  'Counting down to: ${_formatTarget(snapshot.data!.startTime)}'),
              Text(_formatDurationToTarget(snapshot.data!.startTime),
                  style: Theme.of(context).textTheme.headline4)
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}
