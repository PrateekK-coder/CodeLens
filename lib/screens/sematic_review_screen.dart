import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/semantic_review_result_screen.dart';


class SemanticReviewScreen extends StatefulWidget {
  const SemanticReviewScreen({super.key});

  @override
  State<SemanticReviewScreen> createState() =>
      _SemanticReviewScreenState();
}

class _SemanticReviewScreenState
    extends State<SemanticReviewScreen> {

      bool _isSearching = false;
      bool _isLoading = false;


   Future<void> _performSemanticReview() async {
  if (selectedRepository == null) {
    return;
  }

  final query = queryController.text.trim();

  if (query.isEmpty) {
    return;
  }

  final repositoryId =
      selectedRepository!['repository_id'] as String;

  setState(() {
    _isLoading = true;
  });

  try {
    final result = await ApiService.semanticReview(
      repositoryId: repositoryId,
      query: query,
      k: 5,
    );

    print('SEMANTIC REVIEW RESULT: $result');

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => SemanticReviewResultScreen(
      result: result,
      repositoryName: selectedRepository!['name'],
      query: query,
    ),
  ),
);

    // Result screen will be connected next.
    
  } catch (e) {
    print('SEMANTIC REVIEW ERROR: $e');

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Semantic review failed: $e',
        ),
      ),
    );
  }
}



  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor =
      Color(0xFFFFF5F5);

  static const Color headerColor =
      Color(0xFFF7D6D0);

  static const Color accentColor =
      Color(0xFFE2B4BD);

  static const Color primaryText =
      Color(0xFF2D2929);

  static const Color secondaryText =
      Color(0xFF7B6F6F);

  // ============================================================
  // MOCK INDEXED REPOSITORIES
  //
  // Backend will replace this later.
  // ============================================================

final List<Map<String, dynamic>> indexedRepositories = [];

  Map<String, dynamic>? selectedRepository;

  // ============================================================
  // QUERY CONTROLLER
  // ============================================================

  final TextEditingController queryController =
      TextEditingController();

  // ============================================================
  // SUGGESTED QUERIES
  // ============================================================

  final List<String> suggestedQueries = [
    'Auth flow',
    'API interactions',
    'Database',
    'Error handling',
  ];

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  // ============================================================
  // CHECK WHETHER SEARCH CAN BE PERFORMED
  // ============================================================

  bool get canSearch {
    return selectedRepository != null &&
        queryController.text.trim().isNotEmpty;
  }

  // ============================================================
  // SELECT SUGGESTED QUERY
  // ============================================================

  void _selectSuggestion(String suggestion) {

    String query;

    switch (suggestion) {

      case 'Auth flow':
        query =
            'How does authentication flow through the application?';
        break;

      case 'API interactions':
        query =
            'How are API interactions handled across the application?';
        break;

      case 'Database':
        query =
            'Where is database access handled in the application?';
        break;

      case 'Error handling':
        query =
            'How does the application handle errors?';
        break;

      default:
        query = suggestion;
    }

    setState(() {
      queryController.text = query;

      queryController.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: queryController.text.length,
        ),
      );
    });
  }

  // ============================================================
  // REPOSITORY SELECTOR
  // ============================================================

  void _showRepositorySelector() {

    showModalBottomSheet(
      context: context,

      backgroundColor: backgroundColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      builder: (context) {

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              24,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // --------------------------------------------------
                // HANDLE
                // --------------------------------------------------

                Center(
                  child: Container(
                    width: 42,
                    height: 4,

                    decoration: BoxDecoration(
                      color: const Color(0xFFD8C6C6),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Select indexed repository',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 16),

                // --------------------------------------------------
                // REPOSITORIES
                // --------------------------------------------------

                ...indexedRepositories.map(
                  (repository) {

                    final bool isSelected =
                        selectedRepository ==
                            repository;

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 10,
                      ),

                      child: GestureDetector(

                        onTap: () {

                          setState(() {
                            selectedRepository =
                                repository;
                          });

                          Navigator.pop(context);
                        },

                        child: Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets.all(14),

                          decoration:
                              BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            border: Border.all(
                              color: isSelected
                                  ? accentColor
                                  : const Color(
                                      0xFFE8DCDC,
                                    ),

                              width:
                                  isSelected
                                      ? 1.5
                                      : 1,
                            ),
                          ),

                          child: Row(
                            children: [

                              // --------------------------------
                              // REPOSITORY ICON
                              // --------------------------------

                              Container(
                                width: 44,
                                height: 44,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF7D6D0,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                ),

                                child: const Icon(
                                  Icons
                                      .folder_outlined,

                                  color:
                                      Color(
                                    0xFF805B60,
                                  ),

                                  size: 22,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              // --------------------------------
                              // REPOSITORY INFO
                              // --------------------------------

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      repository[
                                          'name'],

                                      style:
                                          const TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w500,
                                        color:
                                            primaryText,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      '${repository['files']} files • '
                                      '${repository['chunks']} chunks',

                                      style:
                                          const TextStyle(
                                        fontSize: 11,
                                        color:
                                            secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color:
                                      Color(0xFF805B60),
                                  size: 21,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // INDEX NEW REPOSITORY
  // ============================================================

  void _showIndexRepositorySheet() {

    final githubController =
        TextEditingController();

    final branchController =
        TextEditingController(
      text: 'main',
    );

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: backgroundColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      builder: (context) {

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 22,

            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    24,
          ),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // --------------------------------------------------
                // HANDLE
                // --------------------------------------------------

                Center(
                  child: Container(
                    width: 42,
                    height: 4,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFD8C6C6),

                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Index a new repository',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Index your repository before performing semantic search.',

                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 22),

                // --------------------------------------------------
                // GITHUB URL
                // --------------------------------------------------

                const Text(
                  'GitHub repository',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: githubController,

                  keyboardType:
                      TextInputType.url,

                  decoration:
                      _inputDecoration(
                    hint:
                        'https://github.com/user/repository',
                    icon:
                        Icons.link_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                // --------------------------------------------------
                // BRANCH
                // --------------------------------------------------

                const Text(
                  'Branch',

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: branchController,

                  decoration:
                      _inputDecoration(
                    hint: 'main',
                    icon:
                        Icons.account_tree_outlined,
                  ),
                ),

                const SizedBox(height: 24),

                // --------------------------------------------------
                // INDEX BUTTON
                // --------------------------------------------------

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton.icon(

                   onPressed: () async {

  final githubUrl =
      githubController.text.trim();

  final branch =
      branchController.text.trim().isEmpty
          ? 'main'
          : branchController.text.trim();

  if (githubUrl.isEmpty) {
    return;
  }

  try {

    // Call backend
  final result =
    await ApiService().indexRepository(
  githubUrl: githubUrl,
  branch: branch,
);

print('INDEX RESULT: $result');

if (!mounted) return;

final repository = {
  'repository_id': result['repository_id'],
  'name': githubUrl
      .split('/')
      .last
      .replaceAll('.git', ''),
  'files': result['files_indexed'],
  'chunks': result['chunks_indexed'],
};

setState(() {
  indexedRepositories.add(repository);
  selectedRepository = repository;
});

Navigator.pop(context);

    // We will handle the returned repository
    // in the next step.

  } catch (e) {

    print('INDEX ERROR: $e');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to index repository: $e',
        ),
      ),
    );
  }
},

                    icon: const Icon(
                      Icons.dataset_rounded,
                      size: 20,
                    ),

                    label: const Text(
                      'Index repository',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF292323,
                      ),

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {

    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFFB4A5A5),
      ),

      prefixIcon: Icon(
        icon,
        size: 19,
        color: const Color(0xFF9B8080),
      ),

      filled: true,

      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: Color(0xFFE8DCDC),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: Color(0xFFE8DCDC),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: accentColor,
          width: 1.5,
        ),
      ),
    );
  }

  // ============================================================
  // MAIN UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: headerColor,

      body: SafeArea(
        child: Stack(
          children: [

            // ======================================================
            // HEADER
            // ======================================================

            Container(
              width: double.infinity,

              color: headerColor,

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                14,
                24,
                30,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ------------------------------------------------
                  // BACK + TITLE
                  // ------------------------------------------------

                  Row(
                    children: [

                      Container(
                        width: 38,
                        height: 38,

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFEAC7C4,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            11,
                          ),
                        ),

                        child: IconButton(
                          padding:
                              EdgeInsets.zero,

                          onPressed: () {
                            Navigator.pop(
                                context);
                          },

                          icon: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color:
                                primaryText,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      const Text(
                        'Semantic review',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              primaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ------------------------------------------------
                  // STEP
                  // ------------------------------------------------

                  const Text(
                    'Step 1 of 1',

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                      color:
                          secondaryText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------

                  const Text(
                    'Explore your codebase',

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w500,
                      color:
                          primaryText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------

                  const Text(
                    'Ask questions and discover related code across your repository.',

                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color:
                          secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // ROUNDED CONTENT PANEL
            // ======================================================

            Positioned(
              top: 213,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(

                decoration:
                    const BoxDecoration(
                  color:
                      backgroundColor,

                  borderRadius:
                      BorderRadius.only(
                    topLeft:
                        Radius.circular(30),
                    topRight:
                        Radius.circular(30),
                  ),
                ),

                child:
                    SingleChildScrollView(

                  padding:
                      const EdgeInsets.fromLTRB(
                    24,
                    26,
                    24,
                    30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // =================================================
                      // REPOSITORY
                      // =================================================

                      const Text(
                        'Repository',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              primaryText,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Select an indexed repository',

                        style: TextStyle(
                          fontSize: 12,
                          color:
                              secondaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // -------------------------------------------------
                      // REPOSITORY SELECTOR
                      // -------------------------------------------------

                      GestureDetector(
                        onTap:
                            _showRepositorySelector,

                        child: Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            border: Border.all(
                              color:
                                  selectedRepository ==
                                          null
                                      ? const Color(
                                          0xFFE8DCDC,
                                        )
                                      : accentColor,
                            ),
                          ),

                          child: Row(
                            children: [

                              Container(
                                width: 40,
                                height: 40,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF7D6D0,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    11,
                                  ),
                                ),

                                child: Icon(
                                  selectedRepository ==
                                          null
                                      ? Icons
                                          .folder_open_outlined
                                      : Icons
                                          .folder_outlined,

                                  size: 21,

                                  color:
                                      const Color(
                                    0xFF805B60,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 11,
                              ),

                              Expanded(
                                child:
                                    selectedRepository ==
                                            null
                                        ? const Text(
                                            'Select repository',
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  14,
                                              color:
                                                  Color(
                                                0xFFA48686,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,

                                            children: [

                                              Text(
                                                selectedRepository![
                                                    'name'],

                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      14,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                  color:
                                                      primaryText,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 3,
                                              ),

                                              Text(
                                                '${selectedRepository!['files']} files • '
                                                '${selectedRepository!['chunks']} chunks',

                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      11,
                                                  color:
                                                      secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                              ),

                              const Icon(
                                Icons
                                    .keyboard_arrow_down_rounded,

                                color:
                                    Color(
                                  0xFF8A7777,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // =================================================
                      // INDEX NEW REPOSITORY
                      // =================================================

                      GestureDetector(

                        onTap:
                            _showIndexRepositorySheet,

                        child: Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 13,
                            horizontal: 14,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFBF2F2,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            border: Border.all(
                              color:
                                  const Color(
                                0xFFE8DCDC,
                              ),
                            ),
                          ),

                          child: Row(
                            children: [

                              Container(
                                width: 34,
                                height: 34,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),

                                child: const Icon(
                                  Icons.add,
                                  size: 19,
                                  color:
                                      Color(
                                    0xFF805B60,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              const Expanded(
                                child: Text(
                                  'Index a new repository',

                                  style:
                                      TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.w500,
                                    color:
                                        primaryText,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons
                                    .chevron_right_rounded,

                                size: 20,

                                color:
                                    Color(
                                  0xFF9B8080,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =================================================
                      // DIVIDER
                      // =================================================

                      Row(
                        children: [

                          Expanded(
                            child: Container(
                              height: 1,
                              color:
                                  const Color(
                                0xFFE9DCDC,
                              ),
                            ),
                          ),

                          const Padding(
                            padding:
                                EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                            ),

                            child: Text(
                              'investigate',

                              style:
                                  TextStyle(
                                fontSize: 10,
                                color:
                                    Color(
                                  0xFFAA9292,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              height: 1,
                              color:
                                  const Color(
                                0xFFE9DCDC,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // =================================================
                      // QUERY
                      // =================================================

                      const Text(
                        'What do you want to investigate?',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              primaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // -------------------------------------------------
                      // QUERY TEXT FIELD
                      // -------------------------------------------------

                      TextField(
                        controller:
                            queryController,

                        maxLines: 4,

                        onChanged: (_) {
                          setState(() {});
                        },

                        decoration:
                            InputDecoration(
                          hintText:
                              'Ask something about your code...',

                          hintStyle:
                              const TextStyle(
                            fontSize: 13,
                            color:
                                Color(
                              0xFFB4A5A5,
                            ),
                          ),

                          filled: true,

                          fillColor:
                              Colors.white,

                          contentPadding:
                              const EdgeInsets.all(
                            15,
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(
                                0xFFE8DCDC,
                              ),
                            ),
                          ),

                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(
                                0xFFE8DCDC,
                              ),
                            ),
                          ),

                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  accentColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =================================================
                      // SUGGESTIONS
                      // =================================================

                      const Text(
                        'Suggested queries',

                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              secondaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,

                        children:
                            suggestedQueries
                                .map(
                          (suggestion) {

                            return GestureDetector(

                              onTap: () {
                                _selectSuggestion(
                                  suggestion,
                                );
                              },

                              child:
                                  Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 13,
                                  vertical: 9,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.white,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),

                                  border:
                                      Border.all(
                                    color:
                                        const Color(
                                      0xFFE8DCDC,
                                    ),
                                  ),
                                ),

                                child:
                                    Text(
                                  suggestion,

                                  style:
                                      const TextStyle(
                                    fontSize: 11,
                                    color:
                                        Color(
                                      0xFF806C6C,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                                .toList(),
                      ),

                      const SizedBox(height: 26),

                      // =================================================
                      // SEARCH BUTTON
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child:
                            ElevatedButton.icon(

                          onPressed:
                               canSearch && !_isLoading
                                ? _performSemanticReview
                                  : null,

                          icon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                          ),

                          label: _isSearching
    ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor:
              AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      )
    : const Text(
        'Find related code',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF292323,
                            ),

                            disabledBackgroundColor:
                                const Color(
                              0xFFFDF8F8,
                            ),

                            foregroundColor:
                                Colors.white,

                            disabledForegroundColor:
                                const Color(
                              0xFFE4D7D7,
                            ),

                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}