class UserProfile {
  String name;
  String phone;
  String email;
  int avatarIndex;
  String upiId;
  String bankAccount;
  String address;

  UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.avatarIndex,
    required this.upiId,
    required this.bankAccount,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'avatarIndex': avatarIndex,
      'upiId': upiId,
      'bankAccount': bankAccount,
      'address': address,
    };
  }
}
