// team.dart

class Team {
  final String name;
  bool checkin;
  bool lunch;
  bool dinner;
  bool checkout;
  List<Member> members;

  Team({
    required this.name,
    this.checkin = false,
    this.lunch = false,
    this.dinner = false,
    this.checkout = false,
    this.members = const [],
  });
}

class Member {
  final String name;
  final String role;

  Member({required this.name, required this.role});
}
