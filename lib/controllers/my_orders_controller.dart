import 'package:get/get.dart';
import 'package:rebuyproject/models/product.dart';

class MyOrdersController extends GetxController {
  final RxInt currentPage = 1.obs;

  final List<Product> myOrders = [
    Product(
      id: '301',
      title: 'Apple AirPods Pro',
      subtitle: '',
      price: '₹ 8,999',
      imageUrl: 'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      date: '21 Jan 2021',
      rating: null, // Not rated yet
    ),
    Product(
      id: '302',
      title: 'JBL Charge 2 Speaker',
      subtitle: '',
      price: '₹ 6,499',
      imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      date: '20 Dec 2020',
      rating: 5.0, // Rated 5 stars
    ),
    Product(
      id: '303',
      title: 'PlayStation Controller',
      subtitle: '',
      price: '₹ 1,299',
      imageUrl: 'https://images.unsplash.com/photo-1592840496073-11298dd1ea4f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      date: '14 Nov 2020',
      rating: null,
    ),
    Product(
      id: '304',
      title: 'Nexus Mountain Bike',
      subtitle: '',
      price: '₹ 9,100',
      imageUrl: 'https://images.unsplash.com/photo-1485965120184-e224f7a1d784?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      date: '05 Oct 2020',
      rating: null,
    ),
    Product(
      id: '305',
      title: 'Wildcraft Ranger Tent',
      subtitle: '',
      price: '₹ 999',
      imageUrl: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      date: '30 Sep 2020',
      rating: null,
    ),
  ];

  void rateProduct(Product product) {
    Get.snackbar('Rate', 'Rate ${product.title}');
  }
}

