import 'package:finca/modules/farms_screen/models/soil_study_model/soil_study_model.dart';
import 'package:hive/hive.dart';

class SoilStudyAdapter extends TypeAdapter<SoilStudyModel> {
  @override
  final int typeId = 0;

  @override
  SoilStudyModel read(BinaryReader reader) {
    return SoilStudyModel(
      uid: reader.read(),
      id: reader.read(),
      path: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, SoilStudyModel obj) {
    writer.write(obj.uid);
    writer.write(obj.id);
    writer.write(obj.path);
  }
}
