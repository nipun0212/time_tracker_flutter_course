import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';
import 'package:time_tracker_flutter_course/app/owner/models/bill.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

import 'auth.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> setOrganization(Organization organization, bool isUpdate);
  Future<void> setBill(Bill bill, bool isUpdate);

  Future<void> deleteJob(Job job);

  Future<void> deleteOrganization(Organization organization);
  Future<void> deleteBill(Bill bill);

  Stream<List<Job>> jobsStream();

  Stream<List<Organization>> organizationsStream(q(Query query));

  Stream<Job> jobStream({@required String jobId});

  Future<void> setEntry(Entry entry);

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream({Job job});

  Stream<List<Bill>> billStream(q(Query query));
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.user});
  final User user;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(user.uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> setOrganization(Organization organization, bool isUpdate) async {
    organization.setLastUpdated(user.uid);
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
  Future<void> setBill(Bill bill, bool isUpdate) async {
    if (isUpdate)
      await _service.setData(
        path: APIPath.bills(user.organizationDocId),
        data: bill.toMap(),
      );
    else
      await _service.setData1(
        path: APIPath.bill(user.organizationDocId, bill.id),
        data: bill.toMap(),
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
    await _service.deleteData(path: APIPath.job(user.uid, job.id));
  }

  @override
  Future<void> deleteOrganization(Organization organization) async {
    await _service.deleteData(path: APIPath.organization(organization.id));
  }

  @override
  Future<void> deleteBill(Bill bill) async {
    await _service.deleteData(
        path: APIPath.bill(user.organizationDocId, bill.id));
  }

  @override
  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: APIPath.job(user.uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(user.uid),
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

  @override
  Stream<List<Bill>> billStream(q(Query query)) => _service.collectionStream(
      path: APIPath.bills(user.organizationDocId),
      builder: (data, documentId) => Bill.fromMap(data, documentId),
      queryBuilder: q);

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(user.uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(user.uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(user.uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
