
class Chef {
  final String id;
  final String chefId;
  final String bio;
  final String username;
  final int experience;
  final List<String> specialties;
  final double rating;
  final String availabilityStatus;
  final double pricingPerHour;
  final String profileVerificationStatus;
  final bool verifiedBadge;
  final String profileImage;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final bool isVerified;
  final String backgroundImage;
  final String gigImage;
  final List<BookedDate> bookedDates;

  Chef({
    required this.id,
    required this.chefId,
    required this.bio,
    required this.experience,
    required this.specialties,
    required this.rating,
    required this.availabilityStatus,
    required this.pricingPerHour,
    required this.profileVerificationStatus,
    required this.verifiedBadge,
    required this.bookedDates,
    required this.name,
    required this.email,
    required this.address,
    required this.type,
    required this.isVerified,
    required this.profileImage,
    this.backgroundImage = "",
    this.gigImage = "",
    this.username = "",
    required this.password,
  });

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      id: json['_id'] ?? '',
      chefId: json['ChefID'] ?? '',
      bio: json['Bio'] ?? '',
      experience: json['Experience'] ?? 0,
      specialties: List<String>.from(json['Specialties'] ?? []),
      rating: (json['Rating'] ?? 0).toDouble(),
      availabilityStatus: json['AvailabilityStatus'] ?? '',
      pricingPerHour: (json['PricingPerHour'] ?? 0).toDouble(),
      profileVerificationStatus: json['ProfileVerificationStatus'] ?? '',
      verifiedBadge: json['VerifiedBadge'] ?? false,
      bookedDates: (json['BookedDates'] as List? ?? [])
          .map((date) => BookedDate.fromJson(date))
          .toList(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? '',
      isVerified: json['isVerified'] ?? false,
      profileImage: json['profileImage'] ?? '',
      password: json['password'] ?? '',
      backgroundImage: json['BackgroundImage'] ?? '',
      gigImage: json['GigImage'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ChefID': chefId,
      'Bio': bio,
      'Experience': experience,
      'Specialties': specialties,
      'Rating': rating,
      'AvailabilityStatus': availabilityStatus,
      'PricingPerHour': pricingPerHour,
      'ProfileVerificationStatus': profileVerificationStatus,
      'VerifiedBadge': verifiedBadge,
      'profileImage': profileImage,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'isVerified': isVerified,
      'GigImage': gigImage,
      'BackgroundImage': backgroundImage,
      'username': username,
      'BookedDates': bookedDates.map((date) => date.toJson()).toList(),
    };
  }
}

class BookedDate {
  final String date;
  final String bookingId;
  final String id;

  BookedDate({
    required this.date,
    required this.bookingId,
    required this.id,
  });

  factory BookedDate.fromJson(Map<String, dynamic> json) {
    return BookedDate(
      date: json['date'] ?? '',
      bookingId: json['bookingId'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'bookingId': bookingId,
      '_id': id,
    };
  }
}
