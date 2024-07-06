import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:starwars/layers/domain/entity/film.dart';
import 'package:starwars/layers/domain/usecase/get_all_starships.dart';
import 'package:stream_transform/stream_transform.dart';

part 'film_page_event.dart';
part 'film_page_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class StarshipPageBloc extends Bloc<StarshipPageEvent, StarshipPageState> {
  StarshipPageBloc({
    required GetAllStarships getAllStarship,
  })  : _getAllStarship = getAllStarship,
        super(const StarshipPageState()) {
    on<FetchNextPageEvent>(
      _fetchNextPage,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  final GetAllStarships _getAllStarship;

  Future<void> _fetchNextPage(event, Emitter<StarshipPageState> emit) async {
    if (state.hasReachedEnd) return;

    emit(state.copyWith(status: StarshipPageStatus.loading));

    final list = await _getAllStarship(page: state.currentPage);

    emit(
      state.copyWith(
        status: StarshipPageStatus.success,
        starships: List.of(state.starships)..addAll(list),
        hasReachedEnd: list.isEmpty,
        currentPage: state.currentPage + 1,
      ),
    );
  }
}