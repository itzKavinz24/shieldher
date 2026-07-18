class ContactModel {
  final int? id;
  final String name;
  final String phone;
  final String relationship;
  final String uid;

  ContactModel({
  this.id,
  required this.uid,
  required this.name,
  required this.phone,
  required this.relationship,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }

  factory ContactModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ContactModel(
      id: map['id'],
      uid: map['uid'],
      name: map['name'],
      phone: map['phone'],
      relationship: map['relationship'],
    );
  }
}