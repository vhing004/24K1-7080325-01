import 'package:flutter/material.dart';
import 'package:timer_counter/events/event_model.dart';
import 'package:timer_counter/events/event_service.dart';
import 'package:flutter_gen/gen_l10n/appp_localization.dart';

// Man hinh chi tiet su kien, cho phep them moi or cap nhat
class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final subjectController = TextEditingController();
  final notesController = TextEditingController();
  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    subjectController.text = widget.event.subject;
    notesController.text = widget.event.notes ?? '';
  }

  Future<void> pickDateTime({required bool isStart}) async {
    // Hien hop thoai chon gio
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: isStart ? widget.event.startTime : widget.event.endTime,
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStart ? widget.event.startTime : widget.event.endTime),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedDate.hour,
            pickedDate.minute,
          );
          if (isStart) {
            widget.event.startTime = newDateTime;
            if (widget.event.startTime.isAfter(widget.event.endTime)) {
              widget.event.endTime = widget.event.startTime.add(
                const Duration(hours: 1),
              );
            }
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    widget.event.subject = subjectController.text;
    widget.event.notes = notesController.text;
    await eventService.saveEvent(widget.event);

    if (!mounted) return;
    Navigator.of(context).pop(true); // Tro ve ma hinh trc do
  }

  Future<void> _deleteEvent() async {
    await eventService.deleteEvent(widget.event);

    if (!mounted) return;
    Navigator.of(context).pop(true); // Tro ve ma hinh trc do
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.id == null ? al.addEvent : al.eventDetail),
      ),
    );
  }
}
