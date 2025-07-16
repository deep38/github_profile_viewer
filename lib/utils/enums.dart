enum LoadingState {
  initial,
  loading,
  success,
  error,
}


enum SortBy {
  name("Name"),
  stars("Stars"),
  updatedDate("Updated date");

  const SortBy(this.title);

  final String title;
}

enum SortOrder {
  asc,
  desc,
}