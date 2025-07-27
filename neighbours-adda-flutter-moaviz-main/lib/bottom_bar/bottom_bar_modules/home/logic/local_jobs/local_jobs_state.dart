import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_jobs_response.dart';

class LocalJobsState extends Equatable {
  final bool dataLoading;
  final List<LocalJob> jobs;
  final String? error;

  const LocalJobsState({
    required this.dataLoading,
    required this.jobs,
    this.error,
  });

  LocalJobsState copyWith({
    bool? dataLoading,
    List<LocalJob>? jobs,
    String? error,
  }) {
    return LocalJobsState(
      dataLoading: dataLoading ?? this.dataLoading,
      jobs: jobs ?? this.jobs,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'jobs': jobs.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory LocalJobsState.fromMap(Map<String, dynamic> map) {
    return LocalJobsState(
      dataLoading: map['dataLoading'] ?? false,
      jobs: List<LocalJob>.from(
        (map['jobs'] ?? []).map((x) => LocalJob.fromMap(x)),
      ),
      error: map['error'],
    );
  }

  @override
  List<Object?> get props => [dataLoading, jobs, error];
} 