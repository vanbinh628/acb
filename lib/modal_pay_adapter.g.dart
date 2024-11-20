// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modal_pay_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModalPayAdapter extends TypeAdapter<ModalPay> {
  @override
  final int typeId = 0;

  @override
  ModalPay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModalPay(
      bank: fields[4] as String,
      barCode: fields[6] as String,
      content: fields[7] as String,
      date: fields[0] as String,
      nameFrom: fields[3] as String,
      nameTo: fields[2] as String,
      stkFrom: fields[5] as String,
      time: fields[1] as String,
      category: fields[8] as String,
      tien: fields[9] as String,
      stkTo: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModalPay obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.nameTo)
      ..writeByte(3)
      ..write(obj.nameFrom)
      ..writeByte(4)
      ..write(obj.bank)
      ..writeByte(5)
      ..write(obj.stkFrom)
      ..writeByte(6)
      ..write(obj.barCode)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.tien)
      ..writeByte(10)
      ..write(obj.stkTo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModalPayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
