enum GtdHotelSortOption {
  recommended("Đề xuất", "order", "DESC"),
  priceAsc("Giá thấp nhất", "price", "ASC"),
  priceDesc("Giá cao nhất", "price", "DESC"),
  starAsc("Xếp hạng sao (từ thấp đến cao)", "starRating", "ASC"),
  starDesc("Xếp hạng sao (từ cao đến thấp)", "starRating", "DESC"),
  guestAsc("Đánh giá thấp", "guestRating", "ASC"),
  guestDesc("Đánh giá cao", "guestRating", "DESC");

  final String title;
  final String sortField;
  final String sortOrder;
  const GtdHotelSortOption(this.title, this.sortField, this.sortOrder);
}
