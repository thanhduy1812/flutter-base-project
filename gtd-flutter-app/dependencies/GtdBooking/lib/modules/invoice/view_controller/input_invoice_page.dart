import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_booking/modules/invoice/view_model/input_invoice_page_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/cubit/saved_companies_cubit.dart';
import 'package:gtd_booking/modules/personal_info/view_model/saved_company_list_viewmodel.dart';
import 'package:gtd_booking/modules/personal_info/views/saved_company_list.dart';
import 'package:gtd_utils/base/bloc/cubit/rebuild_widget_cubit.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/base/view_model/gtd_validate_field_vm.dart';
import 'package:gtd_utils/data/configuration/color_config/app_color.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_button.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_text_field.dart';
import 'package:gtd_utils/utils/popup/gtd_present_view_helper.dart';

import '../../personal_info/cubit/country_codes_cubit.dart';
import '../../personal_info/view_model/nationality_list_viewmodel.dart';
import '../../personal_info/views/nationality_list.dart';

class InputInvoicePage extends BaseStatelessPage<InputInvoicePageViewModel> {
  static const String route = "/inputInvoicePage";
  // final ScrollController _scrollController = ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  const InputInvoicePage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    // var savedTravellersViewModel = SaveTravellerListViewModel(travellers: []);
    return BlocProvider(
      create: (context) => SavedCompaniesCubit()..getListSavedCompany(),
      child: BlocBuilder<SavedCompaniesCubit, SavedCompaniesState>(
        builder: (savedCompanyContext, savedCompanyState) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () => GtdPresentViewHelper.presentView(
                      title: "Danh sách Doanh Nghiệp đã lưu",
                      hasInsetBottom: false,
                      contentPadding: const EdgeInsets.all(0),
                      context: pageContext,
                      builder: Builder(
                        builder: (context) {
                          // return const SizedBox();
                          return SavedCompanyList(
                            viewModel: SavedCompanyListViewModel(
                                companies: (savedCompanyState as SavedCompaniesInitial).savedCompanies),
                            onSelect: (value) {
                              print(value);
                              // viewModel.updateTraveller(value);
                              viewModel.updateFromSavedCompany(value.model);
                              Navigator.pop(context);
                              BlocProvider.of<RebuildWidgetCubit>(pageContext).rebuildWidget();
                            },
                          );
                        },
                      )),
                  child: Ink(
                    decoration: BoxDecoration(gradient: AppColors.appGradient),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                          child: Icon(Icons.save_sharp),
                        ),
                        Text(
                          "Danh sách doanh nghiệp đã lưu",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "Thông tin doanh nghiệp \n",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                            TextSpan(
                                text: "Vui lòng cung cấp thông tin chính xác theo GPKD",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                          ]),
                        ),
                      ),
                    ),
                    buildCompanyInputInfo(pageContext),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "Thông tin người nhận hoá đơn \n",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.boldText)),
                            TextSpan(
                                text:
                                    "Vui lòng cung cấp thông tin chính xác, hóa đơn sẽ được xuất dưới dạng hóa đơn điện tử và gửi đến quý khách qua email sau khi giao dịch đặt chỗ thành công.",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.subText)),
                          ]),
                        ),
                      ),
                    ),
                    buildReceivedInfos(pageContext),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: GtdButton(
                                  text: "Xoá",
                                  height: 50,
                                  color: Colors.white,
                                  colorText: AppColors.normalText,
                                  border: const Border.fromBorderSide(
                                    BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  borderRadius: 25,
                                  onPressed: (value) {
                                    viewModel.removeAll();
                                    BlocProvider.of<RebuildWidgetCubit>(pageContext).rebuildWidget();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                flex: 1,
                                child: GtdButton(
                                  text: "Xác nhận",
                                  height: 50,
                                  color: AppColors.buttonColor,
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: AppColors.buttonColor,
                                      width: 0.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  borderRadius: 25,
                                  onPressed: (value) {
                                    pageContext.pop(viewModel.confirmInvoiceBookingInfo);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.symmetric(vertical: 16))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter buildCompanyInputInfo(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 0,
          color: Colors.white,
          child: BlocProvider(
            create: (nationalityContext) => CountryCodesCubit(countries: viewModel.countries),
            child: BlocBuilder<CountryCodesCubit, CountryCodesState>(
              builder: (nationalityContext, state) {
                return Column(
                  children: [
                    ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var companyInputVM = viewModel.conpanyInfos[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Ink(
                              color: Colors.white,
                              child: GtdTextField(
                                height: 61,
                                viewModel: companyInputVM,
                                rightIcon: companyInputVM.inputUserBehavior == GtdInputUserBehavior.selection
                                    ? const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      )
                                    : null,
                                onSelect: () {
                                  if (companyInputVM.selectType == GtdInputSelectType.city) {
                                  } else if (companyInputVM.selectType == GtdInputSelectType.country) {
                                    return GtdPresentViewHelper.presentView<String>(
                                      title: companyInputVM.label,
                                      contentPadding: EdgeInsets.zero,
                                      hasInsetBottom: false,
                                      context: nationalityContext,
                                      builder: Builder(
                                        builder: (context) {
                                          return NationalityList(
                                            viewModel: NationalityListViewModel(countries: state.countries),
                                            onSelect: (value) {
                                              Navigator.pop(context);
                                              companyInputVM.text = value.model.name ?? "";
                                              BlocProvider.of<RebuildWidgetCubit>(nationalityContext).rebuildWidget();
                                            },
                                          );
                                        },
                                      ),
                                      onChanged: (result) {
                                        print("selected country field");
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: viewModel.conpanyInfos.length),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildReceivedInfos(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 0,
          color: Colors.white,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var receivedInputVM = viewModel.receivedInfos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Ink(
                    color: Colors.white,
                    child: GtdTextField(
                      height: 61,
                      viewModel: receivedInputVM,
                      rightIcon: receivedInputVM.inputUserBehavior == GtdInputUserBehavior.selection
                          ? const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            )
                          : null,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: viewModel.receivedInfos.length),
        ),
      ),
    );
  }
}
