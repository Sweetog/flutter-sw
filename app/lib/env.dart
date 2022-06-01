import 'package:meta/meta.dart';

enum BuildFlavor { live, test }

BuildEnvironment get env => _env!;
BuildEnvironment? _env;

class BuildEnvironment {
  /// The backend server.
  final String functionsUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({required this.flavor, required this.functionsUrl});

  /// Sets up the top-level [env] getter on the first call only.
  static void init({@required flavor, @required functionsUrl}) => _env ??=
      BuildEnvironment._init(flavor: flavor, functionsUrl: functionsUrl);
}
