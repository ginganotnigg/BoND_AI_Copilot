import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/prompt/models/prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bond/features/prompt/bloc/prompt_bloc.dart';
import 'package:bond/features/prompt/bloc/prompt_event.dart';
import 'package:bond/features/prompt/bloc/prompt_state.dart';
import 'prompt_tile.dart';
import 'prompt_dialog.dart';

class PromptList extends StatefulWidget {
  const PromptList({super.key});

  @override
  _PromptListState createState() => _PromptListState();
}

class _PromptListState extends State<PromptList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchSubject = BehaviorSubject<String>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PromptCategory? _selectedCategory;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Debounce search input
    _searchSubject
        .debounceTime(const Duration(milliseconds: 300))
        .listen((query) {
      _loadPrompts(query, _selectedCategory);
    });

    _scrollController.addListener(_onScroll);

    _loadPrompts();
  }

  void _onTabChanged() {
    final promptBloc = BlocProvider.of<PromptBloc>(context);
    promptBloc.currentTabIndex = _tabController.index;
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
    });

    _loadPrompts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePrompts();
    }
  }

  void _loadPrompts([String query = '', PromptCategory? category]) {
    final promptBloc = BlocProvider.of<PromptBloc>(context);
    switch (_tabController.index) {
      case 0:
        promptBloc.add(LoadPromptsEvent(
          isPublic: false,
          limit: 10,
          offset: 0,
          query: query,
        ));
        break;
      case 1:
        promptBloc.add(LoadPromptsEvent(
          isPublic: true,
          isFavorite: false,
          limit: 10,
          offset: 0,
          query: query,
          category: category,
        ));
        break;
      case 2:
        promptBloc.add(LoadPromptsEvent(
          isPublic: true,
          isFavorite: true,
          limit: 10,
          offset: 0,
          query: query,
        ));
        break;
    }
  }

  void _loadMorePrompts() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final promptBloc = BlocProvider.of<PromptBloc>(context);
    final currentState = promptBloc.state;
    if (currentState is PromptLoaded) {
      promptBloc.add(LoadPromptsEvent(
        isPublic: _tabController.index == 1 || _tabController.index == 2,
        isFavorite: _tabController.index == 2,
        limit: 10,
        offset: currentState.prompts.length,
        query: _searchController.text,
        category: _selectedCategory,
      ));
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchSubject.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Private'),
            Tab(text: 'Public'),
            Tab(text: 'Favourite'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _searchSubject.add(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: secondaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_tabController.index ==
                    1) // Show category filter only for public tab
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton<PromptCategory>(
                      value: _selectedCategory,
                      hint: const Text('Category'),
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _loadPrompts(_searchController.text, category);
                      },
                      items:
                          PromptCategory.values.map((PromptCategory category) {
                        return DropdownMenuItem<PromptCategory>(
                          value: category,
                          child: Text(category
                              .toString()
                              .split('.')
                              .last
                              .toUpperCase()),
                        );
                      }).toList(),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.add, color: primaryColor),
                  onPressed: () => showPromptDialog(context, isEdit: false),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPromptList(),
                _buildPromptList(),
                _buildPromptList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptList() {
    return BlocBuilder<PromptBloc, PromptState>(
      builder: (context, state) {
        if (state is PromptLoading && !_isLoadingMore) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PromptLoaded) {
          if (state.prompts.isEmpty) {
            return const Center(child: Text('No prompts available'));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.prompts.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.prompts.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final prompt = state.prompts[index];
              return PromptTile(prompt, _tabController.index);
            },
          );
        } else if (state is PromptError) {
          return Center(child: Text('Failed to load prompts: ${state.error}'));
        } else {
          return const Center(child: Text('No prompts available'));
        }
      },
    );
  }
}

void showPromptManagementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            length: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        PromptList(),
                        PromptList(),
                        PromptList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
