import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gtd_utils/base/view_model/base_page_view_model.dart';
import 'package:gtd_utils/data/cache_helper/models/gtd_account_hive.dart';
import 'package:gtd_utils/data/cache_helper/user_manager.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/authentication_resource/models/request/update_customer_request.dart';
import 'package:gtd_utils/data/repositories/gtd_api_client/authentication_resource/models/request/update_traveller_request.dart';
import 'package:gtd_utils/data/repositories/gtd_repositories/gtd_authentication_repository/gtd_authentication_repository.dart';
import 'package:gtd_utils/helpers/extension/date_time_extension.dart';
import 'package:gtd_utils/helpers/extension/string_extension.dart';
import 'package:gtd_utils/utils/gtd_widgets/gtd_date_picker_scroll/flutter_datetime_picker.dart';
import 'package:gtd_utils/utils/popup/gtd_loading.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class AccountEditPageViewModel extends BasePageViewModel {
  AccountEditPageViewModel() {
    title = 'account.yourAccountInfo'.tr();
    account = UserManager.shared.currentAccount;

    final dob = account?.dateOfBirth;
    String dobStr = '';
    if (dob != null) {
      dobStr = dob.localDate(pattern1);
    }
    form = FormGroup(
      {
        AccountEditFieldNames.firstName.value: FormControl<String>(value: account?.firstName ?? ''),
        AccountEditFieldNames.lastName.value: FormControl<String>(value: account?.lastName ?? ''),
        AccountEditFieldNames.dateOfBirth.value: FormControl<String>(value: dobStr),
        AccountEditFieldNames.nationality.value: FormControl<String>(value: ''),
        AccountEditFieldNames.email.value: FormControl<String>(value: account?.email ?? ''),
        AccountEditFieldNames.passportNumber.value: FormControl<String>(value: ''),
        AccountEditFieldNames.passportCountry.value: FormControl<String>(value: ''),
        AccountEditFieldNames.passportExpireDate.value: FormControl<String>(value: ''),
        AccountEditFieldNames.memberAccountType.value: FormControl<String>(value: ''),
        AccountEditFieldNames.memberAccountNumber.value: FormControl<String>(value: ''),
      },
    );
    final currentGender = _getGenderFromString(account?.gender);
    genderStream.add(currentGender);
  }

  late FormGroup form;
  late BuildContext context;
  GtdAccountHive? account;
  final genderStream = BehaviorSubject<GenderValueEnum>.seeded(GenderValueEnum.male);

  selectExpireDate() async {
    final currentValue = AccountEditFieldNames.passportExpireDate.formValue(form);
    DateTime currentDate = DateTime.now();
    if (currentValue.isNotEmpty) {
      currentDate = currentValue.toDateTime(pattern1);
    }
    final dob = await GtdDatePickerScroll.showDatePicker(
      context,
      title: AccountEditFieldNames.passportExpireDate.title(),
      currentTime: currentDate,
      confirmText: 'global.confirm'.tr(),
    );
    if (dob != null) {
      form.control(AccountEditFieldNames.passportExpireDate.value).value = dob.localDate(pattern1);
    }
  }

  selectDOB() async {
    final currentValue = AccountEditFieldNames.dateOfBirth.formValue(form);
    DateTime currentDOB = DateTime.now();
    if (currentValue.isNotEmpty) {
      currentDOB = currentValue.toDateTime(pattern1);
    }
    final dob = await GtdDatePickerScroll.showDatePicker(
      context,
      maxTime: DateTime.now(),
      title: AccountEditFieldNames.dateOfBirth.title(),
      currentTime: currentDOB,
      confirmText: 'global.confirm'.tr(),
    );
    if (dob != null) {
      form.control(AccountEditFieldNames.dateOfBirth.value).value = dob.localDate(pattern1);
    }
  }

  submitUpdate() async {
    GtdLoading.show();
    String? dobStr;
    String dobInput = AccountEditFieldNames.dateOfBirth.formValue(form);
    if (dobInput.isNotEmpty) {
      dobStr = dobInput.toDateString(
        inputPattern: pattern1,
        outputPattern: iosPattern,
      );
    }

    final response = await GtdAuthenticationRepository.shared.updateTraveller(
      UpdateTravellerRequest(
        id: account?.travellerId,
        profileId: account?.profileId,
        email: AccountEditFieldNames.email.formValue(form),
        firstName: AccountEditFieldNames.firstName.formValue(form),
        surName: AccountEditFieldNames.lastName.formValue(form),
        dob: dobStr,
        gender: genderStream.value.value.toUpperCase(),
        isDefault: true,
        adultType: 'ADT',
        customerCode: 'C::A::1|${account?.profileId}',
        memberCards: [],
        phoneNumber1: '',
      ),
    );
    if (response.isSuccess()) {
      final _ = await GtdAuthenticationRepository.shared.updateCustomer(
        UpdateCustomerRequest(
          ///profile id
          id: account?.profileId,
          defaultTravellerId: account?.travellerId,
          loginId: account?.id,
          loginUsername: AccountEditFieldNames.email.formValue(form),
          customerClass: account?.membershipClass,
          status: 'ACTIVATED',
        ),
      );
    }
    GtdLoading.hide();
  }

  GenderValueEnum _getGenderFromString(String? genderValue) {
    if (genderValue == null) return GenderValueEnum.male;
    if (genderValue.toLowerCase() == GenderValueEnum.male.value) {
      return GenderValueEnum.male;
    }
    return GenderValueEnum.female;
  }
}

enum GenderValueEnum {
  male('male'),
  female('female');

  const GenderValueEnum(this.value);

  final String value;
}

extension GenderValueEnumExt on GenderValueEnum {
  String title() {
    return 'global.$value'.tr();
  }
}

enum AccountEditFieldNames {
  firstName('firstName'),
  lastName('lastName'),
  dateOfBirth('dateOfBirth'),
  nationality('nationality'),
  email('email'),
  passportNumber('passportNumber'),
  passportCountry('passportCountry'),
  passportExpireDate('passportExpireDate'),
  memberAccountType('memberAccountType'),
  memberAccountNumber('memberAccountNumber');

  const AccountEditFieldNames(this.value);

  final String value;
}

extension AccountEditFieldNamesExt on AccountEditFieldNames {
  String title() {
    switch (this) {
      case AccountEditFieldNames.firstName:
        return 'account.register.yourFirstName'.tr();
      case AccountEditFieldNames.lastName:
        return 'account.register.lastName'.tr();
      case AccountEditFieldNames.dateOfBirth:
        return 'account.accountEditPage.dateOfBirth'.tr();
      case AccountEditFieldNames.nationality:
        return 'account.accountEditPage.nationality'.tr();
      case AccountEditFieldNames.email:
        return 'Email';
      case AccountEditFieldNames.passportNumber:
        return 'account.accountEditPage.passportInfo'.tr();
      case AccountEditFieldNames.passportCountry:
        return 'account.accountEditPage.passportCountry'.tr();
      case AccountEditFieldNames.passportExpireDate:
        return 'account.accountEditPage.passportExpireDate'.tr();
      case AccountEditFieldNames.memberAccountType:
        return 'account.accountEditPage.chooseAccountType'.tr();
      case AccountEditFieldNames.memberAccountNumber:
        return 'account.accountEditPage.inputAccountNumber'.tr();
    }
  }

  RegExp typingExpression() {
    switch (this) {
      case AccountEditFieldNames.firstName:
      case AccountEditFieldNames.lastName:
      case AccountEditFieldNames.dateOfBirth:
      case AccountEditFieldNames.nationality:
      case AccountEditFieldNames.passportCountry:
      case AccountEditFieldNames.passportExpireDate:
      case AccountEditFieldNames.memberAccountType:
        return RegExp(r'[A-Za-z ]');
      case AccountEditFieldNames.email:
        return RegExp(r'[A-Z0-9a-z@_\\.]');
      case AccountEditFieldNames.passportNumber:
      case AccountEditFieldNames.memberAccountNumber:
        return RegExp(r'[0-9]');
    }
  }

  TextInputType inputType() {
    switch (this) {
      case AccountEditFieldNames.firstName:
      case AccountEditFieldNames.lastName:
      case AccountEditFieldNames.dateOfBirth:
      case AccountEditFieldNames.nationality:
      case AccountEditFieldNames.passportCountry:
      case AccountEditFieldNames.passportExpireDate:
      case AccountEditFieldNames.memberAccountType:
        return TextInputType.text;
      case AccountEditFieldNames.email:
        return TextInputType.emailAddress;
      case AccountEditFieldNames.passportNumber:
      case AccountEditFieldNames.memberAccountNumber:
        return TextInputType.number;
    }
  }

  String formValue(FormGroup form) {
    return form.control(value).value;
  }
}
