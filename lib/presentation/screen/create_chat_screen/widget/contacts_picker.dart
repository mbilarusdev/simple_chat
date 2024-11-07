import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat/core/bloc/pick_users_bloc.dart';

import 'package:simple_chat/core/helpers.dart';
import 'package:simple_chat/core/widget/button.dart';

import 'package:simple_chat/data/model.dart';
import 'package:simple_chat/router.dart';

import '../../../../core/widget/selected_contacts_widget.dart';

class ContactsPicker extends StatefulWidget {
  final List<User> pickedUsers;
  const ContactsPicker({super.key, required this.pickedUsers});

  @override
  State<ContactsPicker> createState() => _ContactsPickerState();
}

class _ContactsPickerState extends State<ContactsPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SimpleChatButton(
            icon: Icons.phone,
            text: 'Выберите контакты',
            isSecondColor: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              context.pushNamed(
                RouteNames.createChatSearchContacts,
                extra: context.read<PickUsersBloc>(),
              );
            }),
        if (widget.pickedUsers.isNotEmpty) ...[
          SizedBox(height: UnitSystem.unitX2),
          SelectedContactsWidget(
            contacts: widget.pickedUsers,
          ),
        ],
      ],
    );
  }
}
