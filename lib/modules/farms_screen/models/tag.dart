class Tag {
  String name;
  bool isSelected;

  Tag(this.name, this.isSelected);

  // from json
  Tag.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isSelected = false;

  @override
  String toString() {
    return 'Tag{name: $name, isSelected: $isSelected}';
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other;
  }
}
