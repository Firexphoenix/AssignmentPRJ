//package Service;
//
//import model.Cart;
//import model.Product;
//
//public class CartService implements ICartService {
//
//    private static final double DISCOUNT_RATE = 0.10; // 10% discount
//
//    @Override
//    public void addToCart(Cart cart, Product product, int quantity) {
//        cart.addItem(product, quantity);
//    }
//
//    @Override
//    public void updateCartItem(Cart cart, int productId, int quantity) {
//        cart.updateItem(productId, quantity);
//    }
//
//    @Override
//    public void removeCartItem(Cart cart, int productId) {
//        cart.clearCart();
//    }
//
//    @Override
//    public double getTotalPrice(Cart cart) {
//        double total = cart.getItems().stream()
//                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
//                .sum();
//        
//        return total * (1 - DISCOUNT_RATE);
//    }
//}
