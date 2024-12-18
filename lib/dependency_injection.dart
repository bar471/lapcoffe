import '../bindings/connection_bindings.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
  }
}
