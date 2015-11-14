package addition;
class Creator {
  static public function create(klass, arguments) {
    return Type.createInstance(Type.resolveClass(Type.getClassName(klass)), arguments);
  }
}