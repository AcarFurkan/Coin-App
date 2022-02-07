part of 'search_page_cubit.dart';

@immutable
abstract class SearchPageState {}

class SearchPageInitial extends SearchPageState {}

class SearchPageLoading extends SearchPageState {}

class SearchPageItemNotFound extends SearchPageState {}

class SearchPageCompleted extends SearchPageState {
  List<GechoAllIdList> foundIdList;
  SearchPageCompleted({
    required this.foundIdList,
  });
}

class SearchPageError extends SearchPageState {}
