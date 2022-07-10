class Request {
  // static String baseUrl = 'http://localhost/shop_app/shop_backend/api/';
  static String baseUrl = 'https://ashopie.herokuapp.com/api/';
  static String registration = baseUrl + 'register.php';
  static String login = baseUrl + 'login.php';
  static String getProductList = baseUrl + 'get_product_list.php';
  static String addCart = baseUrl + 'add-to-cart.php';
  static String getCart = baseUrl + 'cart-details.php';
  static String makeOrder = baseUrl + 'make-order.php';
  static String showOrder = baseUrl + 'order-made.php';
  static String cancelOrder = baseUrl + 'cancel-order.php';
  static String completeOrder = baseUrl + 'installment-payment.php';
  static String removeCart = baseUrl + 'remove-from-cart.php';
  static String imageUrl =
      'https://ashopie.herokuapp.com/assets/uploads/';
}
