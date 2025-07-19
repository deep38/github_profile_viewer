import 'package:flutter/material.dart';
import 'package:github_profile_viewer/presentation/components/shimmer_loading.dart';
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
    return RepositoryListHeaderLayout(
      label: Text(
        Strings.publicReposLabel,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      sortBy: DropdownButton<SortBy>(
        icon: Icon(Icons.sort),
        underline: SizedBox(),
        items: SortBy.values.map((sortOrder) {
          return DropdownMenuItem<SortBy>(
            value: sortOrder,
            child: Text(
              sortOrder.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
        value: sortBy,
        onChanged: onSortByChange,
      ),
      sortOrder: DropdownButton<SortOrder>(
        icon: Icon(Icons.swap_vert),
        underline: SizedBox(),
        items: SortOrder.values.map((sortOrder) {
          return DropdownMenuItem<SortOrder>(
            value: sortOrder,
            child: Text(
              sortOrder.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
        value: sortOrder,
        onChanged: onSortOrderChange,
      ),
      searchBar: SearchBar(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: Dimens.paddingXSmall,
            horizontal: Dimens.paddingSmall,
          ),
        ),
        elevation: WidgetStatePropertyAll(0),
        onChanged: (v) {
          onSearchQueryChange(v);
        },
        leading: Icon(Icons.search_rounded),
        trailing: [
          if (searchTextEditingController.text.isNotEmpty)
            IconButton(
              onPressed: onClearSearch,
              icon: Icon(Icons.close_rounded),
            ),
        ],
        controller: searchTextEditingController,
        hintText: "Search",
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

class ShimmerRepositoryListHeader extends StatelessWidget {
  const ShimmerRepositoryListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryListHeaderLayout(
      label: ShimmerLine(width: Dimens.lineWidthMedium),
      sortBy: ShimmerLine(width: Dimens.lineWidthXSmall),
      sortOrder: ShimmerLine(width: Dimens.lineWidthXXSmall),
      searchBar: ShimmerLine(height: Dimens.lineHeightLarge),
    );
  }
}

class RepositoryListHeaderLayout extends StatelessWidget {
  const RepositoryListHeaderLayout({
    super.key,
    required this.label,
    required this.sortBy,
    required this.sortOrder,
    required this.searchBar,
  });

  final Widget label;
  final Widget sortBy;
  final Widget sortOrder;
  final Widget searchBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            label,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                sortBy,
                SizedBox(width: Dimens.paddingSmall),
                sortOrder,
              ],
            ),
          ],
        ),
        SizedBox(height: Dimens.paddingXSmall),
        searchBar,
      ],
    );
  }
}
