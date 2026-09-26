import 'package:flutter/material.dart';
import 'repository_review_screen.dart';
import 'file_Review_screen.dart';
import 'sematic_review_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ------------------------------------------------------------
  // APP COLORS
  // ------------------------------------------------------------

  static const Color backgroundColor = Color(0xFFFFF5F5);
  static const Color headerColor = Color(0xFFF7D6D0);
  static const Color accentColor = Color(0xFFE2B4BD);

  static const Color primaryText = Color(0xFF2D2929);
  static const Color secondaryText = Color(0xFF7B6F6F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerColor,

      body: SafeArea(
        child: Stack(
          children: [

            // ====================================================
            // HEADER
            // ====================================================

            Container(
              width: double.infinity,
              color: headerColor,

              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                30,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // ------------------------------------------------
                  // APP LOGO + NAME
                  // ------------------------------------------------

                  Row(
                    children: [

                      Container(
                        width: 48,
                        height: 48,

                        decoration: BoxDecoration(
                          color: const Color(0xFF292323),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.code,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            'Codelens',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),

                          SizedBox(height: 2),

                          Text(
                            'Code review, done properly',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------
                  // HEADER TEXT
                  // ------------------------------------------------

                  const Text(
                    'New review',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Choose a review mode',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ====================================================
            // ROUNDED CONTENT PANEL
            // ====================================================

            Positioned(
              top: 185,
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
                    26,
                    24,
                    30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ------------------------------------------------
                      // DESCRIPTION
                      // ------------------------------------------------

                      const Text(
                        'Pick how much of your codebase Codelens',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryText,
                        ),
                      ),

                      const SizedBox(height: 2),

                      const Text(
                        'should look at.',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryText,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ------------------------------------------------
                      // REPOSITORY REVIEW
                      // ------------------------------------------------

                      ReviewCard(
                        icon: Icons.account_tree_outlined,

                        title: 'Repository review',

                        description:
                            'Clone a repo and review every file for bugs, quality, and performance.',

                        tag1: 'Full codebase',
                        tag2: '~3 min',

                        highlighted: true,

                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const RepositoryReviewScreen(),
                        ),
                          );
                            },
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // FILE REVIEW
                      // ------------------------------------------------

                      ReviewCard(
                        icon: Icons.description_outlined,

                        title: 'File review',

                        description:
                            'Upload or paste a single file for a focused, line-by-line pass.',

                        tag1: 'Single file',
                        tag2: '~30 sec',

                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const FileReviewScreen(),
                          ),
                        );
                      },
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // SEMANTIC REVIEW
                      // ------------------------------------------------

                      ReviewCard(
                        icon: Icons.account_tree_outlined,

                        title: 'Semantic review',

                        description:
                            'Trace how a change affects related functions and call sites.',

                        tag1: 'Cross-file logic',
                        tag2: '~4 min',

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SemanticReviewScreen(),
                            ),
                          );
                        },
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


// ================================================================
// REVIEW CARD
// ================================================================

class ReviewCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String description;

  final String tag1;
  final String tag2;

  final bool highlighted;

  final VoidCallback onTap;

  const ReviewCard({
    super.key,

    required this.icon,
    required this.title,
    required this.description,

    required this.tag1,
    required this.tag2,

    this.highlighted = false,

    required this.onTap,
  });

  static const Color lightPink =
      Color(0xFFF7D6D0);

  static const Color accentPink =
      Color(0xFFE2B4BD);

  static const Color primaryText =
      Color(0xFF2D2929);

  static const Color secondaryText =
      Color(0xFF7B6F6F);

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,

      child: InkWell(

        onTap: onTap,

        borderRadius:
            BorderRadius.circular(17),

        child: Container(

          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(17),

            border: Border.all(

              color: highlighted
                  ? accentPink
                  : const Color(0xFFE8DCDC),

              width:
                  highlighted ? 1.2 : 1,
            ),
          ),

          child: Row(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ------------------------------------------------------
              // ICON
              // ------------------------------------------------------

              Container(

                width: 46,
                height: 46,

                decoration: BoxDecoration(

                  color: highlighted
                      ? accentPink
                      : lightPink,

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(

                  icon,

                  color:
                      const Color(0xFF704E52),

                  size: 23,
                ),
              ),

              const SizedBox(width: 14),

              // ------------------------------------------------------
              // CARD CONTENT
              // ------------------------------------------------------

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        color: primaryText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,

                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: secondaryText,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // ------------------------------------------------
                    // TAGS
                    // ------------------------------------------------

                    Wrap(

                      spacing: 6,

                      children: [

                        ReviewTag(
                          text: tag1,
                        ),

                        ReviewTag(
                          text: tag2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // ------------------------------------------------------
              // ARROW
              // ------------------------------------------------------

              const Padding(

                padding:
                    EdgeInsets.only(top: 18),

                child: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color:
                      Color(0xFFB4A5A5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ================================================================
// REVIEW TAG
// ================================================================

class ReviewTag extends StatelessWidget {

  final String text;

  const ReviewTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),

      decoration: BoxDecoration(

        color:
            const Color(0xFFF2E8E8),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(

        text,

        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF765F61),
        ),
      ),
    );
  }
}