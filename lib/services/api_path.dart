import 'package:time_tracker_flutter_course/app/home/models/organization.dart';

class APIPath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String bills(String organizationId) => 'organizations/$organizationId/bills';
  static String organizations() => 'organizations';
  static String organization(organizationId) => 'organizations/$organizationId';

}
