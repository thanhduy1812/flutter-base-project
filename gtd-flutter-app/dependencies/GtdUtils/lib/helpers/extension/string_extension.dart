extension GtdString on String {
  // packages/resource/vib_assets/images/logo_b2c.svg
  static pathForAsset(String package, String assetName) {
    return 'packages/$package/$assetName';
  }

  static urlForAssetAirlineLogo(String fileName, String assetName) {
    return 'https://750bc7d3dc6109b.cmccloud.com.vn/Booking/AirBooking/images/AirLogos/$assetName.$fileName';
  }

  static pathForAssetGlobal(String package, String assetName) {
    return 'packages/$package/$assetName';
  }

  String removeDiacritics() {
    // Sử dụng biểu thức chính quy để loại bỏ dấu
    return replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'đ'), 'd')
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' '); // Loại bỏ ký tự đặc biệt và thay thế bằng dấu cách
  }
}
