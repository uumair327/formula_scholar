import 'package:equatable/equatable.dart';

class CarouselItem extends Equatable {
  const CarouselItem({
    required this.id,
    required this.imageUrl,
    required this.link,
    required this.isActive,
  });

  final String id;
  final String imageUrl;
  final String link;
  final bool isActive;

  @override
  List<Object?> get props => [id, imageUrl, link, isActive];
}
