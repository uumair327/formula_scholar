import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory CarouselItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarouselItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      link: data['link'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
      displayOrder: data['displayOrder'] as int?,
      bgColor: data['bgColor'] as String?,
    );
  }

  final String id;
  final String title;
  final String imageUrl;
  final String link;
  final bool isActive;
  final int? displayOrder;
  final String? bgColor;

  @override
  List<Object?> get props => [id, title, imageUrl, link, isActive, displayOrder, bgColor];
}
