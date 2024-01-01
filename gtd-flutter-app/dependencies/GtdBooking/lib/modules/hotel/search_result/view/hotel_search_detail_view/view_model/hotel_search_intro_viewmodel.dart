// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gtd_utils/base/view_model/base_view_model.dart';

class HotelSearchIntroViewModel extends BaseViewModel {
  bool isExpand;
  String description =
      "Nằm dọc theo bờ biển Vũng Tàu, Vungtau Intourco Resort cung cấp chỗ nghỉ trang nhã, thoải mái với truy cập Wi-Fi miễn phí trong toàn khuôn viên. Nơi đây có khu vực bãi biển riêng, hồ bơi ngoài trời và trung tâm thể dục. Chỗ nghỉ cách Mũi Nghinh Phong chỉ 300 m và Tượng Chúa Jesu ở Vũng Tàu 400 m. Sân bay Quốc tế Tân Sơn Nhất cách đó khoảng 73 km. Dịch vụ đưa đón và vận chuyển sân bay có thể được cung cấp với một khoản phụ phí. Với sàn lát gạch, các phòng máy lạnh tại đây được trang bị tủ quần áo, giá treo quần áo, két an toàn, minibar và TV truyền hình cáp màn hình phẳng. Phòng tắm riêng đi kèm tiện nghi vòi sen, máy sấy tóc, dép và đồ vệ sinh cá nhân miễn phí. Đội ngũ nhân viên thân thiện tại quầy lễ tân 24 giờ của Vung Tau Intourco Resort có thể hỗ trợ quý khách với dịch vụ cho thuê xe đạp/xe hơi, giặt là và giữ hành lý. Phòng xông hơi khô, dịch vụ mát-xa và tiện nghi hát karaoke cũng được cung cấp tại đây trong khi các tour du lịch được sắp xếp theo yêu cầu. Chỗ nghỉ này có nhà hàng phục vụ các món ăn ngon của địa phương ngay trong khuôn viên. Các bữa ăn cũng có thể được phục vụ ngay trong phòng nghỉ của khách để đảm bảo sự riêng tư.";
  HotelSearchIntroViewModel({
    this.isExpand = false,
  });
  factory HotelSearchIntroViewModel.fromContent(String content) {
    HotelSearchIntroViewModel viewModel = HotelSearchIntroViewModel(isExpand: false);
    viewModel.description = content;
    return viewModel;
  }
}
