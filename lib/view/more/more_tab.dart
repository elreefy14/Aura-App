import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/view/more/component/info.dart';
import 'package:ready_lms/view/more/component/profile.dart';
import 'package:ready_lms/view/more/component/support.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.surface,
      body: Column(
        children: [
          const ProfileWidget(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const Info(),
                Divider(
                  color: context.color.surfaceContainerHighest,
                ),
                const Support()
              ],
            ),
          )),
        ],
      ),
    );
  }
}
