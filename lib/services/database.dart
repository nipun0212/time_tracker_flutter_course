import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/bill.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> setOrganization(Organization organization, bool isUpdate);

  Future<void> deleteJob(Job job);

  Future<void> deleteOrganization(Organization organization);

  Stream<List<Job>> jobsStream();

  Stream<List<Organization>> organizationsStream(q(Query query));

  Stream<Job> jobStream({@required String jobId});

  Future<void> setEntry(Entry entry);

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream({Job job});

  Stream<List<Bill>> billsStream(@required String organizationId);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, @required this.organizationID})
      : assert(uid != null);
  final String uid;
  final organizationID;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> setOrganization(Organization organization, bool isUpdate) async {
    organization.setLastUpdated(uid);
    if (isUpdate)
      await _service.setData(
        path: APIPath.organization(organization.id),
        data: organization.toMap(),
      );
    else
      await _service.setData1(
        path: APIPath.organizations(),
        data: organization.toMap(),
      );
  }

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Future<void> deleteOrganization(Organization organization) async {
    await _service.deleteData(path: APIPath.organization(organization.id));
  }

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Organization>> organizationsStream(q(Query query)) =>
      _service.collectionStream(
          path: APIPath.organizations(),
          builder: (data, documentId) => Organization.fromMap(data, documentId),
          queryBuilder: q
//      queryBuilder:(query)=> q(query)!=null?q(query):null
          );

  Stream<List<Bill>> billsStream(@required String organizationId) {
    return _service.collectionStream(
      path: APIPath.bills(organizationId),
      builder: (data, documentId) => Bill.fromMap(data, documentId),
    );
  }

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
