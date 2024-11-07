import 'package:flutter/widgets.dart';
import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/presentation/screen/create_chat_screen/widget/contact_circleview.dart';
import 'package:simple_chat/theme.dart';

class SelectedContactsWidget extends StatefulWidget {
  final List<User> contacts;

  const SelectedContactsWidget({
    super.key,
    required this.contacts,
  });

  @override
  State<SelectedContactsWidget> createState() => _SelectedContactsWidgetState();
}

class _SelectedContactsWidgetState extends State<SelectedContactsWidget> {
  late final ScrollController controller;
  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectedContactsWidget oldWidget) {
    final width = MediaQuery.of(context).size.width - UnitSystem.unitX4;
    final contactsWidth = ((UnitSystem.unit + ContactCircleview.size) * widget.contacts.length);
    final jumpPosition = contactsWidth > width ? contactsWidth - width : 0.0;
    controller.jumpTo(jumpPosition);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'Выбранные контакты:',
          style: SimpleChatFonts.boldText(),
        ),
      ]),
      const SizedBox(height: UnitSystem.unit),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: widget.contacts.map((user) => ContactCircleview(user: user)).toList(),
              ),
            ),
          ),
        ],
      )
    ]);
  }
}
