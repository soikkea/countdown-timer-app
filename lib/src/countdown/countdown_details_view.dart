import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
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
      ),
      body: Center(
        child: CountdownTimerDetails(id: args.id)
      ),
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

  @override
  void initState() {
    super.initState();
    countdownTimer = Provider.of<CountdownTimerProvider>(context, listen: false)
        .getCountdownTimer(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: FutureBuilder<CountdownTimer>(future: countdownTimer,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // TODO: show more info
        return Text(snapshot.data!.name);
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      return const CircularProgressIndicator();
    },));
  }
}
