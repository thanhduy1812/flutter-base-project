import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dvt_helper/dvt_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  CacheHelper.shared.initCachedMemory();
  // String pathAsset = await rootBundle.loadString('assets/env/${GtdAppMode.prodvib.envFile}');
  // String pathForAsset =
  //     GtdString.pathForAsset(AppConst.shared.commonResource, 'assets/env/.${GtdAppScheme.prodvib.envFile}');
  // await dotenv.load(fileName: '${AppConst.packageCommnon}/assets/env/${GtdAppMode.prodvib.envFile}');
  // await dotenv.load(fileName: pathForAsset);
  // AppConst.shared.appScheme = GtdAppScheme.uatvib;
  Logger.setLogLevel(Logger.DEBUG);
  // runApp(const TestApiApp());
  // runApp(const MyApp());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () async {},
        child: const Text('Call API'),
      ),
    );
  }
}


