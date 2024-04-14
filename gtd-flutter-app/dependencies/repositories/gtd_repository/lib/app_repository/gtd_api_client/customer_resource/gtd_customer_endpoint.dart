import 'package:dvt_network/dvt_network.dart';

import '../../common_model/gtd_environment.dart';

class GtdCustomerEndpoint extends GtdEndpoint {
  GtdCustomerEndpoint({required super.env, required super.path});
  static const String kSavedTravellers = '/api/customers/travellers';
  static const String kSavedCompanies = '/utilitysrv/api/approval-invoices/saved-business';

  static GtdEndpoint getSavedTravellers(GTDEnvType envType) {
    const path = kSavedTravellers;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }

    static GtdEndpoint getSavedCompanies(GTDEnvType envType) {
    const path = kSavedCompanies;
    return GtdEndpoint(env: GtdEnvironment(env: envType), path: path);
  }
}
