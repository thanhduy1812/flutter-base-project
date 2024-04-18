enum BookingFinalStatus {
  bookPending("BOOK_PENDING"),
  bookOnProcess("BOOK_ON_PROCESS"),
  bookFailed("BOOK_FAILED"),
  bookCancelled("BOOK_CANCELLED"),
  bookExpired("BOOK_EXPIRED"),
  paymentPending("PAYMENT_PENDING"),
  paymentOnProcess("PAYMENT_ON_PROCESS"),
  paymentFailed("PAYMENT_FAILED"),
  issuedPending("ISSUED_PENDING"),
  issuedOnProcess("ISSUED_ON_PROCESS"),
  issuedFailed("ISSUED_FAILED"),
  issuedSucceeded("ISSUED_SUCCEEDED");

  final String value;
  const BookingFinalStatus(this.value);
  static BookingFinalStatus? findByStatus(String finalStatus) {
    return BookingFinalStatus.values.where((element) => element.value == finalStatus).firstOrNull;
  }
}
