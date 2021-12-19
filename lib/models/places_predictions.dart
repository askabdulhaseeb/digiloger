class PlacesPredictions {
  PlacesPredictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
  PlacesPredictions(
      {required this.description,
      required this.placeId,
      required this.mainText,
      required this.secondaryText});

  String description = "";
  String placeId = "";
  String mainText = "";
  String secondaryText = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    data['structured_formatting']['main_text'] = mainText;
    data['structured_formatting']['secondary_text'] = secondaryText;
    return data;
  }
}
