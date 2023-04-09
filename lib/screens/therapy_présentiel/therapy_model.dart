class Therapy {
  final String id;
  final String image;
  final String titre;
  final String date;
  final String address;
  final String description;
  late int capacity;

  Therapy(
      this.id, this.image, this.titre, this.date, this.address,this .description, dynamic capacity)
      : capacity = capacity is int ? capacity : int.tryParse(capacity) ?? 0;

  setCapacity(int newCapacity) {
    capacity = newCapacity;
  }
}
