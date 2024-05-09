import 'package:finca/models/notification/notification_model.dart';
import 'package:finca/utils/collection_refs.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final data = await CollectionRefs.instance.notifications(userId).get();
    return data.docs.map(
          (e) {
        return NotificationModel.fromJson(e.data());
      },
    ).toList();
  }
}
