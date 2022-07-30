import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCountdownTimerView extends StatelessWidget {
  const EditCountdownTimerView({Key? key}) : super(key: key);

  static const routeName = '/edit_countdown_timer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Countdown')),
      body: const CountdownTimerForm(),
    );
  }
}

class CountdownTimerForm extends StatefulWidget {
  const CountdownTimerForm({Key? key}) : super(key: key);

  @override
  State<CountdownTimerForm> createState() => _CountdownTimerFormState();
}

class _CountdownTimerFormState extends State<CountdownTimerForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              controller: nameController,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO handle valid data
                    final newCountdown = CountdownTimer(
                        id: 0,
                        name: nameController.text,
                        startTime: DateTime.now().add(const Duration(days: 30)).toUtc(),
                        createdAt: DateTime.now().toUtc());
                    Provider.of<CountdownTimerProvider>(context, listen: false)
                        .add(newCountdown);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('New Countdown added!')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'))
          ],
        ));
  }
}
