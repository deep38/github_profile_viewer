import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/enums.dart';

class RepositoryListHeader extends StatelessWidget {
  const RepositoryListHeader({
    super.key,
    required this.onSearchQueryChange,
    required this.sortBy,
    required this.onSortByChange,
    required this.sortOrder,
    required this.onSortOrderChange,
    required this.searchTextEditingController,
    required this.onClearSearch,
  });

  final void Function(String) onSearchQueryChange;
  final SortBy sortBy;
  final void Function(SortBy?) onSortByChange;
  final SortOrder sortOrder;
  final void Function(SortOrder?) onSortOrderChange;
  final TextEditingController searchTextEditingController;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Public repositories",
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButton<SortBy>(
              icon: Icon(Icons.sort),
              underline: SizedBox(),
              items: SortBy.values.map((sortOrder) {
                return DropdownMenuItem<SortBy>(
                  value: sortOrder,
                  child: Text(sortOrder.title, style: Theme.of(context).textTheme.bodyMedium,),
                );
              }).toList(),
              value: sortBy,
              onChanged: onSortByChange,
            ),
            SizedBox(width: Dimens.paddingSmall),
            DropdownButton<SortOrder>(
              icon: Icon(Icons.swap_vert),
              underline: SizedBox(),
              items: SortOrder.values.map((sortOrder) {
                return DropdownMenuItem<SortOrder>(
                  value: sortOrder,
                  child: Text(sortOrder.name, style: Theme.of(context).textTheme.bodyMedium),
                );
              }).toList(),
              value: sortOrder,
              onChanged: onSortOrderChange,
            ),
          ],
        ),
        SizedBox(height: 4),
        SearchBar(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4, horizontal: Dimens.paddingSmall),
          ),
          elevation: WidgetStatePropertyAll(0),
          onChanged: (v) {
            onSearchQueryChange(v);},
          leading: Icon(Icons.search_rounded),
          trailing: [
            if(searchTextEditingController.text.isNotEmpty)
            IconButton(onPressed: onClearSearch, icon: Icon(Icons.close_rounded))
          ],
          controller: searchTextEditingController,
          hintText: "Search",
          textInputAction: TextInputAction.search,
        ),
      ],
    );
  }
}
