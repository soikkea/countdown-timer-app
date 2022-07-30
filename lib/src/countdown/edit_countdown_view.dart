import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _nameController = TextEditingController();
  DateTime _target = DateTime.now();
  final _targetController = TextEditingController();

  TimeOfDay get _targetTimeOfDay => TimeOfDay.fromDateTime(_target);

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickTargetDateTime() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _target,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (date == null) {
      return;
    }
    final time =
        await showTimePicker(context: context, initialTime: _targetTimeOfDay);
    if (time == null) {
      return;
    }
    setState(() {
      _target = _combineDateAndTime(date, time);
    });
  }

  String _formatTarget() {
    return DateFormat("yyyy-MM-dd HH:mm").format(_target);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _targetController.text = _formatTarget();

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              controller: _nameController,
            ),
            TextFormField(
              controller: _targetController,
              decoration: const InputDecoration(labelText: 'Target'),
              readOnly: true,
              onTap: () {
                _pickTargetDateTime();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO handle valid data
                    final newCountdown = CountdownTimer(
                        id: 0,
                        name: _nameController.text,
                        startTime: _target.toUtc(),
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
