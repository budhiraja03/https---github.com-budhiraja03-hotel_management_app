class Guest {
  final String roomNo;
  final String name;
  final String email;
  final int age;
  final String phone;
  final String address;
  final double paidPrice;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  Guest({required this.roomNo,
    required this.name,
    required this.email,
    required this.checkInDate,
    required this.age,
    required this.paidPrice,
    required this.phone,
    required this.address,
    required this.checkOutDate,
  });

}