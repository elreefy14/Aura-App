import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/notification.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/view/notification/component/notification_card.dart';

import '../../generated/l10n.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final ScrollController scrollController = ScrollController();
  int itemPerPage = 20;
  int pageNumber = 2;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      _loadMore();
    }
  }

  _loadMore() {
    if (ref.read(notificationProvider.notifier).totalNotificationCount %
            itemPerPage !=
        0) {
      return;
    }
    ref.read(notificationProvider.notifier).getNotification(
          itemPerPage: itemPerPage,
          pageNumber: pageNumber,
        );
    pageNumber++;
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        title: Text(S.of(context).notifications),
        actions: [
          TextButton(
            onPressed: () {
              bool isUnReadExist =
                  ref.read(notificationProvider.notifier).isUnReadExist();
              if (isUnReadExist) {
                ref.read(notificationProvider.notifier).markAllAsRead();
              }
            },
            child: Text(S.of(context).markallasread),
          )
        ],
      ),
      body: notificationState.when(
          data: (notifications) => notifications.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).noNotification,
                    style: AppTextStyle(context).bodyText,
                  ),
                )
              : ListView.separated(
                  controller: scrollController,
                  itemBuilder: (context, index) =>
                      NotificationCard(model: notifications[index]),
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    endIndent: 20,
                    indent: 20,
                  ),
                  itemCount: notifications.length,
                ),
          error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
