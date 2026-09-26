import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/repository_review_result_screen.dart';

class RepositoryReviewScreen extends StatefulWidget {
  const RepositoryReviewScreen({super.key});

  @override
  State<RepositoryReviewScreen> createState() =>
      _RepositoryReviewScreenState();
}

class _RepositoryReviewScreenState
    extends State<RepositoryReviewScreen> {
  final TextEditingController repositoryController =
      TextEditingController();

  final TextEditingController branchController =
      TextEditingController(text: 'main');

    bool _isLoading = false;


    String _getRepositoryName(String url) {
  final cleaned = url
      .trim()
      .replaceAll(RegExp(r'/$'), '')
      .replaceAll('.git', '');

  final parts = cleaned.split('/');

  if (parts.isNotEmpty) {
    return parts.last;
  }

  return 'Repository';
}



    Future<void> _reviewRepository() async {
  final githubUrl = repositoryController.text.trim();
  final branch = branchController.text.trim();

  if (githubUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a GitHub repository URL.'),
      ),
    );
    return;
  }

  if (branch.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a branch name.'),
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final result = await ApiService.reviewRepository(
      githubUrl: githubUrl,
      branch: branch,
    );

    debugPrint('REPOSITORY REVIEW RESULT:');
    debugPrint(result.toString());

    if (!mounted) return;
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => RepositoryReviewResultScreen(
      result: result,
      repositoryName: _getRepositoryName(
        repositoryController.text.trim(),
      ),
    ),
  ),
);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Repository review completed successfully.'),
      ),
    );

    // Result screen will be connected in the next step.
  } catch (e) {
    debugPrint('Repository review failed: $e');

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Repository review failed: $e'),
      ),
    );
  }
}
  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const Color backgroundColor = Color(0xFFFFF5F5);
  static const Color headerColor = Color(0xFFF7D6D0);
  static const Color accentColor = Color(0xFFE2B4BD);

  static const Color primaryText = Color(0xFF2D2929);
  static const Color secondaryText = Color(0xFF7B6F6F);

  @override
  void dispose() {
    repositoryController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerColor,

      body: SafeArea(
        child: Stack(
          children: [

            // =====================================================
            // PINK HEADER
            // =====================================================

            Container(
              width: double.infinity,
              color: headerColor,

              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                24,
                30,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // -------------------------------------------------
                  // BACK + TITLE
                  // -------------------------------------------------

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Text(
                        'Repository Review',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // -------------------------------------------------
                  // HEADER DESCRIPTION
                  // -------------------------------------------------

                  const Padding(
                    padding: EdgeInsets.only(left: 8),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Review your entire',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight:
                                FontWeight.w500,
                            color: primaryText,
                          ),
                        ),

                        Text(
                          'repository.',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight:
                                FontWeight.w500,
                            color: primaryText,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Codelens will analyze your codebase for bugs, security issues, quality, and performance.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // ROUNDED CONTENT PANEL
            // =====================================================

            Positioned(
              top: 225,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(

                decoration: const BoxDecoration(
                  color: backgroundColor,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(

                  padding: const EdgeInsets.fromLTRB(
                    24,
                    30,
                    24,
                    30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // =================================================
                      // GITHUB REPOSITORY
                      // =================================================

                      const Text(
                        'GitHub Repository',

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller:
                            repositoryController,

                        keyboardType:
                            TextInputType.url,

                        decoration:
                            InputDecoration(

                          hintText:
                              'https://github.com/user/repository',

                          hintStyle:
                              const TextStyle(
                            color:
                                Color(0xFFB4A5A5),
                            fontSize: 13,
                          ),

                          filled: true,

                          fillColor:
                              Colors.white,

                          prefixIcon:
                              const Icon(
                            Icons.link,
                            color:
                                Color(0xFF8E7376),
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(0xFFE8DCDC),
                            ),
                          ),

                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(0xFFE8DCDC),
                            ),
                          ),

                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color: accentColor,
                              width: 1.5,
                            ),
                          ),

                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // BRANCH
                      // =================================================

                      const Text(
                        'Branch',

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller:
                            branchController,

                        decoration:
                            InputDecoration(

                          hintText: 'main',

                          filled: true,

                          fillColor:
                              Colors.white,

                          prefixIcon:
                              const Icon(
                            Icons.account_tree_outlined,
                            color:
                                Color(0xFF8E7376),
                          ),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(0xFFE8DCDC),
                            ),
                          ),

                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color:
                                  Color(0xFFE8DCDC),
                            ),
                          ),

                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            borderSide:
                                const BorderSide(
                              color: accentColor,
                              width: 1.5,
                            ),
                          ),

                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
  children: [
    _BranchChip(
      label: 'main',
      selected: branchController.text == 'main',
      onTap: () {
        setState(() {
          branchController.text = 'main';
        });
      },
    ),

    const SizedBox(width: 8),

    _BranchChip(
      label: 'develop',
      selected: branchController.text == 'develop',
      onTap: () {
        setState(() {
          branchController.text = 'develop';
        });
      },
    ),

    _BranchChip(
      label: 'staging',
      selected: branchController.text=='staging', 
      onTap:() {
        setState(() {
        branchController.text='staging';
    });
      },
    )
  ],
),

const SizedBox(height: 30),

                      // =================================================
                      // REVIEW BUTTON
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child: ElevatedButton(

                        onPressed: _isLoading ? null : _reviewRepository,

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                const Color(0xFF292323),

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

                         child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              

                            : const Text(
                            'Review Repository',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      
                        )
                      ),
                      const SizedBox(height: 16),

                      // =================================================
                      // INFO CARD
                      // =================================================

                      Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(16),

                        decoration:
                            BoxDecoration(
                          color: headerColor,

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),

                        child: const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color:
                                  Color(0xFF704E52),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                'Make sure the repository is publicly accessible. The review may take a few minutes depending on the size of the codebase.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color:
                                      secondaryText,
                                ),
                              ),
                            ),
                          ],
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

class _BranchChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BranchChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF292323)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          border: Border.all(
            color: selected
                ? const Color(0xFF292323)
                : const Color(0xFFE2B4BD),
          ),
        ),

        child: Text(
          label,

          style: TextStyle(
            fontSize: 12,

            color: selected
                ? Colors.white
                : const Color(0xFF7B6F6F),

            fontWeight: selected
                ? FontWeight.w500
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}