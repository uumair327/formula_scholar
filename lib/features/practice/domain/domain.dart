/// Barrel file for the practice domain layer.
library;

export 'entities/quiz_answer_record.dart';
export 'entities/quiz_question.dart';
export 'entities/quiz_result.dart';
export 'ports/practice_cache_port.dart';
export 'ports/practice_repository_port.dart';
export 'ports/practice_data_source_port.dart';
export 'usecases/get_questions_use_case.dart';
export 'usecases/get_recent_quiz_results_use_case.dart';
export 'usecases/record_quiz_completion_use_case.dart';
export 'usecases/save_quiz_result_use_case.dart';
