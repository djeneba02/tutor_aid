import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_aid/model/role.dart';

Future<void> addRole(Role role) async {
  await FirebaseFirestore.instance.collection('roles').doc(role.id).set(role.toFirestore());
}


Future<List<Role>> fetchRoles() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('roles').get();

  return querySnapshot.docs.map((doc) => Role.fromFirestore(doc)).toList();
}
