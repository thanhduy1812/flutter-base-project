// ignore_for_file: public_member_api_docs, sort_constructors_first
class HotelRoomChildAge {
  int position;
  int? age;
  int minAge = 1;
  int maxAge = 17;
  HotelRoomChildAge({
    required this.position,
    this.age,
    this.minAge = 1,
    this.maxAge = 17
  });



  HotelRoomChildAge copyWith({
    int? position,
    int? age,
    int? minAge,
    int? maxAge,
  }) {
    return HotelRoomChildAge(
      position: position ?? this.position,
      age: age ?? this.age,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }
}
