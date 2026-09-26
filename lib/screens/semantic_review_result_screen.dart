import 'package:flutter/material.dart';

class SemanticReviewResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final String repositoryName;
  final String query;

  const SemanticReviewResultScreen({
    super.key,
    required this.result,
    required this.repositoryName,
    required this.query,
  });

  @override
  State<SemanticReviewResultScreen> createState() =>
      _SemanticReviewResultScreenState();
}

class _SemanticReviewResultScreenState
    extends State<SemanticReviewResultScreen> {

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
  // HELPERS
  // ============================================================

  List<dynamic> get reviews {
    return widget.result['reviews'] ?? [];
  }

  String cleanFilePath(String path) {
    const marker = '/app/data/repositories/';

    if (path.contains(marker)) {
      final index = path.indexOf(marker);

      final cleaned = path.substring(
        index + marker.length,
      );

      final parts = cleaned.split('/');

      if (parts.length > 1) {
        return parts.sublist(1).join('/');
      }

      return cleaned;
    }

    return path;
  }

  // ============================================================
  // SEVERITY COUNTS
  // ============================================================

  int get highCount {
    int count = 0;

    for (final review in reviews) {
      final issues = review['issues'] ?? [];

      for (final issue in issues) {
        if (issue['severity'] == 'HIGH') {
          count++;
        }
      }
    }

    return count;
  }

  int get mediumCount {
    int count = 0;

    for (final review in reviews) {
      final issues = review['issues'] ?? [];

      for (final issue in issues) {
        if (issue['severity'] == 'MEDIUM') {
          count++;
        }
      }
    }

    return count;
  }

  int get lowCount {
    int count = 0;

    for (final review in reviews) {
      final issues = review['issues'] ?? [];

      for (final issue in issues) {
        if (issue['severity'] == 'LOW') {
          count++;
        }
      }
    }

    return count;
  }

  // ============================================================
  // SEVERITY COLOR
  // ============================================================

  Color severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'HIGH':
        return const Color(0xFFB85C5C);

      case 'MEDIUM':
        return const Color(0xFFC58A4A);

      case 'LOW':
        return const Color(0xFF7D9B7D);

      default:
        return secondaryText;
    }
  }

  Color severityBackground(String severity) {
    switch (severity.toUpperCase()) {
      case 'HIGH':
        return const Color(0xFFF8E1E1);

      case 'MEDIUM':
        return const Color(0xFFF8ECD9);

      case 'LOW':
        return const Color(0xFFE7F0E7);

      default:
        return const Color(0xFFF3EAEA);
    }
  }

  // ============================================================
  // SEVERITY BADGE
  // ============================================================

  Widget severityBadge(String severity) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: severityBackground(severity),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        severity,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: severityColor(severity),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY BADGE
  // ============================================================

  Widget categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EEEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF806C6C),
        ),
      ),
    );
  }

  // ============================================================
  // ISSUE CARD
  // ============================================================

  Widget issueCard(Map<String, dynamic> issue) {

    final severity =
        issue['severity']?.toString() ?? 'UNKNOWN';

    final category =
        issue['category']?.toString() ?? 'GENERAL';

    final file =
        issue['file']?.toString() ?? '';

    final line =
        issue['line']?.toString() ?? '';

    final description =
        issue['description']?.toString() ?? '';

    final evidence =
        issue['evidence']?.toString() ?? '';

    final recommendation =
        issue['recommendation']?.toString() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEADDDD),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // --------------------------------------------------------
          // BADGES
          // --------------------------------------------------------

          Row(
            children: [
              severityBadge(severity),

              const SizedBox(width: 7),

              categoryBadge(category),
            ],
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------------
          // DESCRIPTION
          // --------------------------------------------------------

          const Text(
            'Issue',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: secondaryText,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: primaryText,
            ),
          ),

          // --------------------------------------------------------
          // FILE
          // --------------------------------------------------------

          if (file.isNotEmpty) ...[
            const SizedBox(height: 14),

            const Text(
              'File',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: secondaryText,
              ),
            ),

            const SizedBox(height: 5),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8EEEE),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.description_outlined,
                    size: 16,
                    color: Color(0xFF806C6C),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      cleanFilePath(file),
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Color(0xFF6E5D5D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // --------------------------------------------------------
          // LINE
          // --------------------------------------------------------

          if (line.isNotEmpty) ...[
            const SizedBox(height: 9),

            Row(
              children: [
                const Icon(
                  Icons.numbers,
                  size: 14,
                  color: secondaryText,
                ),

                const SizedBox(width: 5),

                Text(
                  'Line $line',
                  style: const TextStyle(
                    fontSize: 11,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ],

          // --------------------------------------------------------
          // EVIDENCE
          // --------------------------------------------------------

          if (evidence.isNotEmpty) ...[
            const SizedBox(height: 14),

            const Text(
              'Evidence',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: secondaryText,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF302B2B),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Text(
                evidence,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],

          // --------------------------------------------------------
          // RECOMMENDATION
          // --------------------------------------------------------

          if (recommendation.isNotEmpty) ...[
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7E9E6),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: Color(0xFF805B60),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'Recommendation',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                            color: Color(
                              0xFF70595C,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          recommendation,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: Color(
                              0xFF6E5D5D,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // REVIEW CARD
  // ============================================================

  Widget reviewCard(
    Map<String, dynamic> review,
    int index,
  ) {

    final summary =
        review['summary']?.toString() ??
            'No summary available.';

    final severity =
        review['overall_severity']?.toString() ??
            'UNKNOWN';

    final issues =
        List<dynamic>.from(
      review['issues'] ?? [],
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8DCDC),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(

          tilePadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 7,
          ),

          childrenPadding:
              const EdgeInsets.fromLTRB(
            14,
            0,
            14,
            8,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),

          collapsedShape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),

          iconColor: secondaryText,

          collapsedIconColor:
              secondaryText,

          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  severityBackground(
                severity,
              ),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              severity == 'HIGH'
                  ? Icons.priority_high_rounded
                  : Icons.code_rounded,
              size: 20,
              color:
                  severityColor(severity),
            ),
          ),

          title: Row(
            children: [

              severityBadge(severity),

              const SizedBox(width: 8),

              Text(
                '${issues.length} '
                '${issues.length == 1 ? 'issue' : 'issues'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
            ],
          ),

          subtitle: Padding(
            padding:
                const EdgeInsets.only(
              top: 7,
            ),
            child: Text(
              summary,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: primaryText,
              ),
            ),
          ),

          children: [

            const Divider(
              color: Color(0xFFEDE1E1),
              height: 18,
            ),

            ...issues.map(
              (issue) => issueCard(
                Map<String, dynamic>.from(
                  issue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY COUNTER
  // ============================================================

  Widget summaryCounter({
    required int count,
    required String label,
    required Color color,
    required Color background,
  }) {

    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius:
              BorderRadius.circular(13),
        ),
        child: Column(
          children: [

            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w600,
                color: color,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w500,
                color: color,
              ),
            ),
          ],
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
                              context,
                            );
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

                  const Text(
                    'Review complete',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                      color: secondaryText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    widget.repositoryName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w500,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // CONTENT PANEL
            // ======================================================

            Positioned(
              top: 181,
              left: 0,
              right: 0,
              bottom: 0,

              child: Container(
                decoration:
                    const BoxDecoration(
                  color: backgroundColor,
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
                    25,
                    24,
                    35,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // =================================================
                      // QUERY
                      // =================================================

                      const Text(
                        'Investigated query',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              secondaryText,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                          14,
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
                                const Color(
                              0xFFE8DCDC,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color:
                                  Color(
                                0xFF805B60,
                              ),
                            ),

                            const SizedBox(
                              width: 9,
                            ),

                            Expanded(
                              child: Text(
                                widget.query,
                                style:
                                    const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color:
                                      primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // REVIEW SUMMARY
                      // =================================================

                      const Text(
                        'Review summary',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              primaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          summaryCounter(
                            count: highCount,
                            label: 'HIGH',
                            color:
                                const Color(
                              0xFFB85C5C,
                            ),
                            background:
                                const Color(
                              0xFFF8E1E1,
                            ),
                          ),

                          const SizedBox(width: 8),

                          summaryCounter(
                            count: mediumCount,
                            label: 'MEDIUM',
                            color:
                                const Color(
                              0xFFC58A4A,
                            ),
                            background:
                                const Color(
                              0xFFF8ECD9,
                            ),
                          ),

                          const SizedBox(width: 8),

                          summaryCounter(
                            count: lowCount,
                            label: 'LOW',
                            color:
                                const Color(
                              0xFF7D9B7D,
                            ),
                            background:
                                const Color(
                              0xFFE7F0E7,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      // =================================================
                      // FINDINGS
                      // =================================================

                      Row(
                        children: [

                          const Expanded(
                            child: Text(
                              'Semantic findings',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
                                color:
                                    primaryText,
                              ),
                            ),
                          ),

                          Text(
                            '${reviews.length} '
                            '${reviews.length == 1 ? 'review' : 'reviews'}',
                            style:
                                const TextStyle(
                              fontSize: 11,
                              color:
                                  secondaryText,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (reviews.isEmpty)
                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .all(18),
                          decoration:
                              BoxDecoration(
                            color: Colors.white,
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
                          child: const Text(
                            'No relevant code issues were found for this query.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color:
                                  secondaryText,
                            ),
                          ),
                        )
                      else
                        ...reviews.asMap().entries.map(
                          (entry) {
                            return reviewCard(
                              Map<String, dynamic>
                                  .from(
                                entry.value,
                              ),
                              entry.key,
                            );
                          },
                        ),

                      const SizedBox(height: 10),

                      // =================================================
                      // FOOTER INFO
                      // =================================================

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                          14,
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
                        ),
                        child: const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Icon(
                              Icons.auto_awesome_outlined,
                              size: 18,
                              color:
                                  Color(
                                0xFF805B60,
                              ),
                            ),

                            SizedBox(width: 9),

                            Expanded(
                              child: Text(
                                'Semantic review uses related code from your indexed repository to provide context-aware findings.',
                                style: TextStyle(
                                  fontSize: 11,
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