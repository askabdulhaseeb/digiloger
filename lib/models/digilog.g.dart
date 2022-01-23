// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digilog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DigilogAdapter extends TypeAdapter<Digilog> {
  @override
  final int typeId = 1;

  @override
  Digilog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Digilog(
      useruid: fields[0] as String,
      location: fields[2] as Location,
      postedTime: fields[3] as String,
      title: fields[5] as String,
    )
      ..digilogid = fields[1] as String
      ..experiences = (fields[4] as List).cast<Experiences>()
      ..comments = (fields[6] as List).cast<Comments>()
      ..likes = (fields[7] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Digilog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.useruid)
      ..writeByte(1)
      ..write(obj.digilogid)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.postedTime)
      ..writeByte(4)
      ..write(obj.experiences)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.comments)
      ..writeByte(7)
      ..write(obj.likes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigilogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationAdapter extends TypeAdapter<Location> {
  @override
  final int typeId = 2;

  @override
  Location read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Location(
      lat: fields[0] as double,
      long: fields[1] as double,
      maintext: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Location obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long)
      ..writeByte(2)
      ..write(obj.maintext);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExperiencesAdapter extends TypeAdapter<Experiences> {
  @override
  final int typeId = 3;

  @override
  Experiences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Experiences(
      mediaUrl: fields[0] as String,
      mediatype: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Experiences obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mediaUrl)
      ..writeByte(1)
      ..write(obj.mediatype)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperiencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentsAdapter extends TypeAdapter<Comments> {
  @override
  final int typeId = 4;

  @override
  Comments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comments(
      uid: fields[0] as String,
      message: fields[1] as String,
      likes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Comments obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.likes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
