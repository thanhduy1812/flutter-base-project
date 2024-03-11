import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd_utils/data/bme_repositories/bme_client/bme_client.dart';
import 'package:gtd_utils/data/bme_repositories/bme_repositories/bme_repository.dart';
import 'package:meta/meta.dart';

part 'bme_user_state.dart';

class BmeUserCubit extends Cubit<BmeUserState> {
  BmeUserCubit() : super(BmeUserInitial(bmeUsers: const []));

  Future<void> loadBmeUsers() async {
    await BmeRepository.shared.getListUser().then((value) {
      value.whenSuccess((success) {
        emit(BmeUserInitial(bmeUsers: success));
      });
    });
  }

  Future<void> loadBmeUsersByClassCode(String classCode) async {
    emit(BmeUserLoading());
    await BmeRepository.shared.findUserByClassCode(classCode).then((value) {
      value.whenSuccess((success) {
        emit(BmeUserInitial(bmeUsers: success));
      });
      value.whenError((error) => emit(BmeUserInitial(bmeUsers: const [])));
    });
  }
}
