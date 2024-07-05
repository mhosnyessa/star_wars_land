import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:starwars/layers/domain/entity/person.dart';

part 'character_details_event.dart';

part 'character_details_state.dart';

class CharacterDetailsBloc
    extends Bloc<CharacterDetailsEvent, CharacterDetailsState> {
  CharacterDetailsBloc({required Person character})
      : super(CharacterDetailsState(character: character));
}
