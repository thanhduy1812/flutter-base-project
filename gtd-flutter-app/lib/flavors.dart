enum Flavor {
  B2C,
  AGENT,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.B2C:
        return 'Gotadi';
      case Flavor.AGENT:
        return 'Gotadi Agent';
      default:
        return 'title';
    }
  }

}
