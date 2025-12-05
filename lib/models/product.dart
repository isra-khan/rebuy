enum ListingStatus { active, hidden, sold }

class Product {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final bool isFavorite;
  final String description;
  final String make;
  final String year;
  final bool hasWarranty;
  final bool hasOriginalPacking;
  final String date;
  final String views;
  final int messageCount;
  final ListingStatus listingStatus;
  final double? rating;
  final DateTime? createdAt;
  
  // Seller Info
  final String sellerName;
  final String sellerLocation;
  final String sellerAvatar;

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.description = 'The Shure SM7B reigns as king of studio recording for good reason: vocal recording and reproduction is clear and crisp, especially when recording in a studio environment.',
    this.make = 'Shure',
    this.year = '2020',
    this.hasWarranty = true,
    this.hasOriginalPacking = false,
    this.date = '',
    this.views = '0',
    this.messageCount = 0,
    this.listingStatus = ListingStatus.active,
    this.rating,
    this.createdAt,
    this.sellerName = 'Cliff Hanger',
    this.sellerLocation = 'El Dorado',
    this.sellerAvatar = 'https://i.pravatar.cc/150?u=cliff',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        // Firebase timestamp is in milliseconds
        createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int);
      } catch (e) {
        createdAt = null;
      }
    }
    
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      subtitle: json['subtitle'],
      price: json['price'],
      imageUrl: json['image_url'],
      description: json['description'],
      make: json['make'],
      year: json['year'],
      hasWarranty: json['has_warranty'],
      hasOriginalPacking: json['has_original_packing'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'image_url': imageUrl,
      'description': description,
      'make': make,
      'year': year,
      'has_warranty': hasWarranty,
      'has_original_packing': hasOriginalPacking,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? price,
    String? imageUrl,
    bool? isFavorite,
    String? description,
    String? make,
    String? year,
    bool? hasWarranty,
    bool? hasOriginalPacking,
    String? date,
    String? views,
    int? messageCount,
    ListingStatus? listingStatus,
    double? rating,
    DateTime? createdAt,
    String? sellerName,
    String? sellerLocation,
    String? sellerAvatar,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      make: make ?? this.make,
      year: year ?? this.year,
      hasWarranty: hasWarranty ?? this.hasWarranty,
      hasOriginalPacking: hasOriginalPacking ?? this.hasOriginalPacking,
      date: date ?? this.date,
      views: views ?? this.views,
      messageCount: messageCount ?? this.messageCount,
      listingStatus: listingStatus ?? this.listingStatus,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      sellerName: sellerName ?? this.sellerName,
      sellerLocation: sellerLocation ?? this.sellerLocation,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
    );
  }
}
