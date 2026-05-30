import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/notifikasi/get_all_notifikasi.dart';
import '../../../domain/usecases/notifikasi/get_unread_notifikasi.dart';
import '../../../domain/usecases/notifikasi/mark_as_read.dart';
import 'notifikasi_event.dart';
import 'notifikasi_state.dart';

@injectable
class NotifikasiBloc extends Bloc<NotifikasiEvent, NotifikasiState> {
  final GetAllNotifikasi getAllNotifikasi;
  final GetUnreadNotifikasi getUnreadNotifikasi;
  final MarkAsRead markAsRead;

  NotifikasiBloc({
    required this.getAllNotifikasi,
    required this.getUnreadNotifikasi,
    required this.markAsRead,
  }) : super(NotifikasiInitial()) {
    on<LoadNotifikasi>((event, emit) async {
      emit(NotifikasiLoading());
      try {
        final unread = await getUnreadNotifikasi();
        final all = await getAllNotifikasi();
        emit(NotifikasiLoaded(unreadNotifikasi: unread, allNotifikasi: all));
      } catch (e) {
        emit(NotifikasiError(e.toString()));
      }
    });

    on<MarkNotifikasiAsRead>((event, emit) async {
      try {
        await markAsRead(event.id);
        add(LoadNotifikasi());
      } catch (e) {
        emit(NotifikasiError(e.toString()));
      }
    });

    on<MarkAllNotifikasiAsRead>((event, emit) async {
      try {
        if (state is NotifikasiLoaded) {
          final loaded = state as NotifikasiLoaded;
          for (var n in loaded.unreadNotifikasi) {
            await markAsRead(n.id!);
          }
        } else {
          final unread = await getUnreadNotifikasi();
          for (var n in unread) {
            await markAsRead(n.id!);
          }
        }
        add(LoadNotifikasi());
      } catch (e) {
        emit(NotifikasiError(e.toString()));
      }
    });
  }
}
