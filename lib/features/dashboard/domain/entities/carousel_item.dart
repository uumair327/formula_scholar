import 'package:equatable/equatable.dart';

class CarouselItem extends Equatable {
  const CarouselItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.link,
    required this.isActive,
    this.displayOrder,
    this.bgColor,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String link;
  final bool isActive;
  final int? displayOrder;
  final String? bgColor;

  @override
  List<Object?> get props => [
    id,
    title,
    imageUrl,
    link,
    isActive,
    displayOrder,
    bgColor,
  ];
}
