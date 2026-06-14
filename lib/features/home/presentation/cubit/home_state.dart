part of 'home_cubit.dart';

enum HomeStatus { loading, loaded }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<PetModel> pets;
  final Map<String, String> iconsKey;

  const HomeState({
    this.status = HomeStatus.loading,
    this.pets = const [],
    this.iconsKey = const {},
  });

  HomeState copyWith({
    HomeStatus? status,
    List<PetModel>? pets,
    Map<String, String>? iconsKey,
  }) {
    return HomeState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      iconsKey: iconsKey ?? this.iconsKey,
    );
  }

  @override
  List<Object?> get props => [status, pets, iconsKey];
}
