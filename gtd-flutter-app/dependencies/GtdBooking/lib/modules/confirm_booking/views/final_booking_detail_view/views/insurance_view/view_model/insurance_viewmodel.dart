import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/item_select_vm.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/inventory_resource.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/inventory_resource/models/response/gtd_insurance_plans_rs.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/common_enum/gtd_insurance_type.dart';
import 'package:gtd_utils/helpers/extension/number_extension.dart';

enum InsuranceViewType { finalView, planView }

class InsuranceViewModel extends ItemSelectVM {
  String title = "Bảo hiểm trễ chuyến Flight Easy";
  String insuranceStatus = " Chưa đăng ký";
  Color insuraceStatusColor = Colors.green;
  GtdInsuranceType? insuranceType = GtdInsuranceType.delay;
  InsuranceViewType viewType = InsuranceViewType.finalView;

  InsuranceClassItem? selectedValue;
  String amount = "";
  double premiumAmount = 0;
  String benefit =
      "Bảo hiểm lên đến 2 tỷ VND cho Quyền lợi tai nạn, bảo hiểm lên tới 25 triệu VND cho hành lý thất lạc và 100 triệu cho hủy chuyến";
  List<InsuranceClassItem> insuranceClassItems = [];

  InsurancePlan? insurancePlan;
  InsuranceViewModel({required super.data});

  factory InsuranceViewModel.fromInsuranceDetail({
    required GtdInsuranceDetail insuranceDetail,
  }) {
    InsuranceViewModel insuraceViewModel = InsuranceViewModel(data: insuranceDetail);

    insuraceViewModel.viewType = InsuranceViewType.finalView;
    insuraceViewModel.insuranceType = insuranceDetail.typeEnum;
    if (insuranceDetail.typeEnum == GtdInsuranceType.delay) {
      insuraceViewModel.title = "Bảo hiểm trễ chuyến Flight Easy";
    } else if (insuranceDetail.typeEnum == GtdInsuranceType.flexi) {
      insuraceViewModel.title = "Bảo hiểm du lịch Flexi";
    }
    insuraceViewModel.insuranceStatus = insuranceDetail.statusEnum?.value ?? "On hold";
    insuraceViewModel.insuraceStatusColor = insuranceDetail.statusEnum?.color ?? Colors.amber;
    insuraceViewModel.amount = insuranceDetail.amount?.toCurrency() ?? "";
    insuraceViewModel.premiumAmount = insuranceDetail.amount ?? 0;

    return insuraceViewModel;
  }

  factory InsuranceViewModel.fromInsurancePlan(
      {required InsurancePlan insurancePlan, InsuranceClassItem? selectedValue}) {
    InsuranceViewModel insuraceViewModel = InsuranceViewModel(data: insurancePlan);
    insuraceViewModel.viewType = InsuranceViewType.planView;
    insuraceViewModel.insurancePlan = insurancePlan;
    insuraceViewModel.benefit = insurancePlan.extras?.insuranceClassItem?.firstOrNull?.benefit ?? "";
    insuraceViewModel.insuranceClassItems = insurancePlan.extras?.insuranceClassItem ?? [];
    // insuraceViewModel.selectedValue = insuraceViewModel.insuranceClassItems.firstOrNull;
    insuraceViewModel.selectedValue = selectedValue;

    if (insurancePlan.extras?.insuranceType == "DELAY") {
      insuraceViewModel.insuranceType = GtdInsuranceType.delay;
      insuraceViewModel.title = "Bảo hiểm trễ chuyến Flight Easy";
      insuraceViewModel.amount = insurancePlan.amount?.toCurrency() ?? "";
      insuraceViewModel.premiumAmount = insurancePlan.amount ?? 0;
    } else if (insurancePlan.extras?.insuranceType == "FLEXI") {
      insuraceViewModel.insuranceType = GtdInsuranceType.flexi;
      insuraceViewModel.title = "Bảo hiểm du lịch Flexi";
      // double amountPerPerson = (insurancePlan.extras?.insuranceBreakdown?.firstOrNull?.premiumAmount ?? 0);
      insuraceViewModel.selectedValue = selectedValue ?? insurancePlan.extras?.insuranceClassItem?.firstOrNull;
      double amountPerPerson = insurancePlan.amount ?? 0;
      int countPerson = (insurancePlan.extras?.personCount ?? 1);
      insuraceViewModel.amount = "${(amountPerPerson / countPerson).toCurrency()} / 1 khách";
      insuraceViewModel.premiumAmount = (amountPerPerson / countPerson);
    }

    return insuraceViewModel;
  }

  void updatePackageFlexi(List<InsurancePlan> insurancePlans) {
    InsurancePlan? flexiInsurance =
        insurancePlans.where((element) => element.extras?.insuranceType == "FLEXI").firstOrNull;
    if (flexiInsurance != null && insuranceType == GtdInsuranceType.flexi) {
      premiumAmount = flexiInsurance.amount ?? 0;
      double amountPerPerson = premiumAmount;
      int countPerson = (insurancePlan?.extras?.personCount ?? 1);
      amount = "${(amountPerPerson / countPerson).toCurrency()} / 1 khách";
    }
  }

  // double get insurancePlanAmount => insurancePlan?.extras?.insuranceBreakdown?.firstOrNull?.premiumAmount ?? 0;

  String get insuranceContent {
    if (insuranceType == GtdInsuranceType.delay) {
      return '''
<p style="font-weight:bold;">Bảo hiểm Trễ chuyến bay Flight Easy:</p>
<p style="font-weight:normal;">
  Gói bảo hiểm áp dụng cho cả hành trình và tổng số khách..
</p>
<p style="font-weight:normal;">
  - Nhận ngay <b>888.000 VNĐ</b> /1 khách/1 chiều cho mỗi chuyến bay bị trễ trên 2 giờ liên tục.<br>
  Sản phẩm được cung cấp bởi Bảo hiểm Bảo Việt. Tham khảo Điều khoản <a href='https://baovietonline.cdn.vccloud.vn/uploads/product/gotadi/flighteasy/policy-Wording.pdf' target='_blank'>chi tiết tại đây </a> 
</p>
''';
    } else if (insuranceType == GtdInsuranceType.flexi) {
      return '''
<p style="font-weight:bold;">Bảo hiểm Du lịch Flexi:</p>
<p style="font-weight:normal;">
  Gói bảo hiểm áp dụng cho cả hành trình và tổng số khách.
</p>
<p style="font-weight:normal;">
  <b> - $benefit</b><br>
  Sản phẩm được cung cấp bởi Bảo hiểm Bảo Việt. Tham khảo chi tiết bảo hiểm du lịch Flexi tại <a href='https://uat-b2c.gotadi.com/assets/files/quyen-loi-flexi.pdf' target='_blank'>Bảng quyền lợi </a> & <a href='https://uat-b2c.gotadi.com/assets/files/quy-tac-flexi.pdf' target='_blank'> quy tắc sản phẩm</a>.
</p>
''';
    }
    return "";
  }
}
