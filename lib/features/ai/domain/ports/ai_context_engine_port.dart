import '../entities/entities.dart';

abstract class AiContextEnginePort {
  Future<AiContextSnapshot> buildSnapshot();
}
