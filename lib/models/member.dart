class Event {
  final String name;
  final List<Team> teams;

  Event({required this.name, required this.teams});
}

class Team {
  final String name;
  bool checkin;
  bool lunch;
  bool snacks;
  bool dinner;
  bool midNi8Snacks;
  bool attendance;
  bool breakfast;
  bool lunch2;
  bool checkout;
  List<Member> members;

  Team({
    required this.name,
    this.checkin = false,
    this.lunch = false,
    this.snacks = false,
    this.dinner = false,
    this.midNi8Snacks = false,
    this.attendance = false,
    this.breakfast = false,
    this.lunch2 = false,
    this.checkout = false,
    this.members = const [],
  });
}

class Member {
  final String name;
  final String role;

  Member({required this.name, required this.role});
}
