class Person {
  String id;
  String userName;
  String name;
  String profilePicturePath;

  Person({
    required this.id,
    required this.userName,
    required this.name,
    required this.profilePicturePath,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      profilePicturePath: json['profilePicturePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'profilePicturePath': profilePicturePath,
    };
  }
}
