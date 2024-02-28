import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtd_utils/base/page/base_stateless_page.dart';
import 'package:gtd_utils/helpers/extension/colors_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_fade_indexed_stack.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_input/gtd_input_msc.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_tap_widget.dart';
import 'package:gtd_utils/utils/popup/gtd_popup_message.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:new_gotadi/app/account/register/register.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterPage extends BaseStatelessPage<RegisterPageViewModel> {
  static const String route = '/register';

  const RegisterPage({super.key, required super.viewModel});

  @override
  Widget buildBody(BuildContext pageContext) {
    return KeyboardDismisser(
      child: ReactiveForm(
        formGroup: viewModel.registerForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterTabBar(
                onTabChanged: (tabIndex) {
                  viewModel.onTabChanged(tabIndex);
                },
              ),
              _registerMessage(),
              GtdSimpleInput(
                formControlName: RegisterFormControlNames.lastName.value,
                stream: viewModel.lastNameValidationStream,
                label: 'account.register.yourLastName'.tr(),
                fieldType: GtdInputValidationField.text,
              ),
              const SizedBox(height: 16),
              GtdSimpleInput(
                formControlName: RegisterFormControlNames.firstName.value,
                stream: viewModel.firstNameValidationStream,
                label: 'account.register.yourFirstName'.tr(),
                fieldType: GtdInputValidationField.text,
              ),
              const SizedBox(height: 16),
              _emailOrPhoneInput(),
              const SizedBox(height: 16),
              _registerBtn(pageContext),
              const SizedBox(height: 16),
              _logInMessage(pageContext),
              const RegisterTermsAndConditions(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailOrPhoneInput() {
    return StreamBuilder<int>(
      stream: viewModel.tabIndexStream.skip(1),
      builder: (context, snapshot) {
        final index = snapshot.data ?? 0;
        return GtdFadeIndexedStack(
          index: index,
          children: [
            SizedBox(
              height: index == 0 ? null : 1,
              child: RegisterEmailSection(
                viewModel: viewModel.emailSectionViewModel,
              ),
            ),
            SizedBox(
              height: index == 1 ? null : 1,
              child: RegisterPhoneSection(
                viewModel: viewModel.phoneSectionViewModel,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _registerBtn(BuildContext pageContext) {
    return StreamBuilder<bool>(
      stream: viewModel.buttonEnableStream,
      builder: (context, snapshot) {
        bool enabled = snapshot.hasData && snapshot.data == true;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GtdTapWidget(
            onTap: () {
              if (enabled) {
                viewModel.onSubmit(
                  onError: (error) {
                    //TODO: show error message
                  },
                  onSuccess: () {
                    GtdPopupMessage.showPopUpWithIcon(
                      context: pageContext,
                      iconAssetPath: 'assets/icons/mail-green.svg',
                      title: 'account.register.success.title'.tr(),
                      cancelText: 'global.close'.tr(),
                      descriptionWidget: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'account.register.success.first'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                color: GtdColors.inkBlack,
                              ),
                            ),
                            TextSpan(
                              text: viewModel.registerForm
                                  .control(RegisterFormControlNames.email.value)
                                  .value,
                              style: TextStyle(
                                fontSize: 16,
                                color: GtdColors.inkBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'account.register.success.second'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                color: GtdColors.inkBlack,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              }
            },
            backgroundColor: enabled
                ? GtdColors.appMainColor(pageContext)
                : GtdColors.snowGrey,
            radius: 24,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'account.registerText'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : GtdColors.stormGray,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _registerMessage() {
    return StreamBuilder<int>(
      stream: viewModel.tabIndexStream,
      builder: (context, snapshot) {
        String methodText = 'account.register.description.byEmail'.tr();
        if (snapshot.data == 1) {
          methodText = 'account.register.description.byPhoneNumber'.tr();
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'account.register.description.first'.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    color: GtdColors.inkBlack,
                  ),
                ),
                TextSpan(
                  text: methodText,
                  style: TextStyle(
                    fontSize: 15,
                    color: GtdColors.inkBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'account.register.description.second'.tr(),
                  style: TextStyle(
                    fontSize: 15,
                    color: GtdColors.inkBlack,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }

  Widget _logInMessage(BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GtdTapWidget(
        onTap: () {
          pageContext.pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'account.register.haveAccountMessage.isMember'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GtdColors.inkBlack,
                    ),
                  ),
                  TextSpan(
                    text: 'account.register.haveAccountMessage.logInNow'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GtdColors.appMainColor(pageContext),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterTabBar extends StatefulWidget {
  final Function(int) onTabChanged;

  const RegisterTabBar({
    required this.onTabChanged,
    super.key,
  });

  @override
  State<RegisterTabBar> createState() => _RegisterTabBarState();
}

class _RegisterTabBarState extends State<RegisterTabBar>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextStyle selectedLabelStyle = TextStyle(
    fontSize: 16,
    color: GtdColors.inkBlack,
  );
  TextStyle unselectedLabelStyle = TextStyle(
    fontSize: 16,
    color: GtdColors.steelGrey,
  );

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      widget.onTabChanged.call(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: GtdColors.blueGrey,
          ),
        ),
      ),
      child: ChangeNotifierProvider.value(
        value: tabController,
        child: Consumer<TabController>(
          builder: (context, controller, child) {
            return TabBar(
              controller: controller,
              indicatorWeight: 0,
              labelPadding: const EdgeInsets.symmetric(vertical: 8),
              indicatorSize: TabBarIndicatorSize.tab,
              enableFeedback: true,
              dividerColor: Colors.transparent,
              indicator: _tabIndicator(),
              tabs: [
                _tabWidget(
                  title: 'Email',
                  selected: controller.index == 0,
                ),
                _tabWidget(
                  title: 'account.phoneNumber'.tr(),
                  selected: controller.index == 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _tabIndicator() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: const Offset(1, 5),
          blurRadius: 5,
          spreadRadius: 2,
          color: Colors.black.withOpacity(0.05),
        ),
      ],
    );
  }

  _tabWidget({required String title, required bool selected}) {
    return Text(
      title,
      style: selected ? selectedLabelStyle : unselectedLabelStyle,
    );
  }
}
