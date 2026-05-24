import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/search/search.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';
import '../../constants/constants.dart';

List<GoRoute> searchRoutes() {
  return [
    GoRoute(
      path: AppRoutes.searchPath,
      name: AppRoutes.searchName,
      pageBuilder: (context, state) {
        return AppPageTransitions.fadeTransition(
          state: state,
          child: BlocProvider(
            create: (_) => getIt<SearchCubit>(),
            child: const SearchPage(),
          ),
        );
      },
    ),
  ];
}

