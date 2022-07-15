class UserData {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String image;
  final String cover;
  final String? bio;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.image =
        'https://as2.ftcdn.net/v2/jpg/03/32/59/65/1000_F_332596535_lAdLhf6KzbW6PWXBWeIFTovTii1drkbT.jpg',
    this.cover =
        'https://img.freepik.com/free-psd/3d-interface-website-presentation-mockup-isolated_359791-208.jpg?w=1060&t=st=1657101837~exp=1657102437~hmac=5b58e14dc4a021416a62363e60b6f332921b23caf281d8d8e7d9a14879434f77',
    this.bio,
  });

  factory UserData.fromJson(dynamic map) {
    return UserData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      image: map['image'] ??
          'https://militaryhealthinstitute.org/wp-content/uploads/sites/37/2021/08/blank-profile-picture-png.png',
      cover: map['cover'] ??
          'https://newevolutiondesigns.com/images/freebies/abstract-facebook-cover-1.jpg',
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
    };
  }
}
