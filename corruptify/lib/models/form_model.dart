class FormModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String contact;
  final String evidanceUrl;
  final String? assignedOfficer; // Optional field
  final String? approvalStatus;
  final String? email; // Optional field

  FormModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      required this.contact,
      required this.evidanceUrl,
      this.assignedOfficer, // Optional
      this.approvalStatus,
      this.email // Optional
      });
}
