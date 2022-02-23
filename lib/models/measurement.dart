class Measurement {
  int? id;
  int? roomWidth;
  int? roomLength;
  String? roomUnits;
  int? tileWidth;
  int? tileLength;
  String? tileUnits;
  int? gapSize;
  String? gapUnits;

  Measurement(
      {this.roomWidth,
      this.roomLength,
      this.roomUnits = 'm',
      this.tileWidth,
      this.tileLength,
      this.tileUnits = 'm',
      this.gapSize,
      this.gapUnits = 'mm'});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomWidth': roomWidth,
      'roomLength': roomLength,
      'roomUnits': roomUnits,
      'tileWidth': tileWidth,
      'tileLength': tileLength,
      'tileUnits': tileUnits,
      'gapSize': gapSize,
      'gapUnits': gapUnits,
    };
  }

  Map<String, void Function(String)> getSetMap() {
    return {
      'id': (String _id) {
        id = int.tryParse(_id) ?? id;
      },
      'roomWidth': (String _roomWidth) {
        roomWidth = int.tryParse(_roomWidth) ?? roomWidth;
      },
      'roomLength': (String _roomLength) {
        roomLength = int.tryParse(_roomLength) ?? roomLength;
      },
      'roomUnits': (String _roomUnits) {
        roomUnits = _roomUnits;
      },
      'tileWidth': (String _tileWidth) {
        tileWidth = int.tryParse(_tileWidth) ?? tileWidth;
      },
      'tileLength': (String _tileLength) {
        tileLength = int.tryParse(_tileLength) ?? tileLength;
      },
      'tileUnits': (String _tileUnits) {
        tileUnits = _tileUnits;
      },
      'gapSize': (String _gapSize) {
        gapSize = int.tryParse(_gapSize) ?? gapSize;
      },
      'gapUnits': (String _gapUnits) {
        gapUnits = _gapUnits;
      },
    };
  }

  Measurement fromJSON(Map<String, Object?> data) {
    var setMap = getSetMap();
    data.forEach((key, value) {
      if (setMap[key] != null) {
        setMap[key]?.call(value.toString());
      }
    });
    return this;
  }

  @override
  String toString() {
    return toMap()
        .map((key, value) => MapEntry(key, "$key: $value"))
        .values
        .join(", ");
  }
}
