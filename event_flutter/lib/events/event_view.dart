import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/appp_localization.dart';

class Event_View extends StatefulWidget {
  const Event_View({super.key});

  @override
  State<Event_View> createState() => _Event_ViewState();
}

class _Event_ViewState extends State<Event_View> {
  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(al.appTitle),
        centerTitle: true,
      ),
    );
  }
}
