import 'package:equatable/equatable.dart';

/// What one pet looks like on screen: the species asset it falls back on, plus
/// the catalogue icon it picked, if any. Carried as one value so a list of pets
/// and a list of icons can never drift apart.
class PetPortrait extends Equatable {
  final String iconKey;
  final String? assetPath;

  const PetPortrait({required this.iconKey, this.assetPath});

  const PetPortrait.species(this.iconKey) : assetPath = null;

  @override
  List<Object?> get props => [iconKey, assetPath];
}
