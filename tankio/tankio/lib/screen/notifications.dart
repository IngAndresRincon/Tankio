import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/models/notification_model.dart';
import 'package:tankio/provider/notification.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {
  @override
  void initState() {
    getNotificationsUser();
    super.initState();
  }

  void getNotificationsUser() async {
    await Future.microtask(() {
      ref.read(notificationProvider).getNotificationsByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final notification = ref.watch(notificationProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: size.width * 0.06,
            ),
          ),
          title: Text(
            l10n.notificationsTitleScreen,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: size.width * 0.044,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
        ),
        body: LiquidPullToRefresh(
          onRefresh: () async {
            ref.read(notificationProvider).getNotificationsByUserId();
          },
          backgroundColor: Colors.black12,
          height: size.height * 0.1,
          color: Colors.transparent,
          showChildOpacityTransition: true,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: notification.listNotification.length,
            itemBuilder: (context, index) {
              final NotificationModel item =
                  notification.listNotification[index];
              return Dismissible(
                key: Key(item.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.deleteNotificationAction,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade600,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      const SizedBox(width: 8),

                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade600,
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  notification.deleteItemNotificationFromList(item.id);
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: const Color(0xFFE9EAEB),
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(Icons.notifications_active_outlined),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.036,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.031,
                            color: const Color(0xFF535862),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          item.registrationDate,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.026,
                            color: const Color(0xFF535862),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
