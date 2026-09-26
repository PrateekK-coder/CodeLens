import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFF5F5);
  static const Color header = Color(0xFFF7D6D0);
  static const Color accent = Color(0xFFE2B4BD);

  static const Color primaryText = Color(0xFF2D2929);
  static const Color secondaryText = Color(0xFF7B6F6F);

  static const Color border = Color(0xFFE8D4D1);
  static const Color white = Colors.white;

  static const Color critical = Color(0xFFE98B8B);
  static const Color high = Color(0xFFFAA0A0);
  static const Color medium = Color(0xFFF2C46D);
  static const Color low = Color(0xFF9ADBC9);
}

class RepositoryReviewResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final String repositoryName;

  const RepositoryReviewResultScreen({
    super.key,
    required this.result,
    required this.repositoryName,
  });

  @override
  State<RepositoryReviewResultScreen> createState() =>
      _RepositoryReviewResultScreenState();
}

class _RepositoryReviewResultScreenState
    extends State<RepositoryReviewResultScreen> {
  String selectedCategory = 'ALL';

  final Map<String, bool> expandedFiles = {};

  // ================================================================
  // DATA
  // ================================================================

  List<dynamic> get issues {
    final value = widget.result['issues'];

    if (value is List) {
      return value;
    }

    return [];
  }

  int get filesReviewed {
    final value = widget.result['files_reviewed'];

    if (value is int) {
      return value;
    }

    return 0;
  }

  int get totalIssues {
    final value = widget.result['total_issues'];

    if (value is int) {
      return value;
    }

    return issues.length;
  }

  Map<String, dynamic> get severityCounts {
    final value = widget.result['severity_counts'];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {
      'CRITICAL': 0,
      'HIGH': 0,
      'MEDIUM': 0,
      'LOW': 0,
    };
  }

  int severityCount(String severity) {
    final value = severityCounts[severity];

    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  // ================================================================
  // FILTERED ISSUES
  // ================================================================

  List<dynamic> get filteredIssues {
    if (selectedCategory == 'ALL') {
      return issues;
    }

    return issues.where((issue) {
      if (issue is! Map) {
        return false;
      }

      return issue['category']
              ?.toString()
              .toUpperCase() ==
          selectedCategory;
    }).toList();
  }

  // ================================================================
  // GROUP ISSUES BY FILE
  // ================================================================

  Map<String, List<dynamic>> get groupedIssues {
    final Map<String, List<dynamic>> grouped = {};

    for (final issue in filteredIssues) {
      if (issue is! Map) {
        continue;
      }

      final file =
          issue['file']?.toString() ?? 'Unknown file';

      grouped.putIfAbsent(file, () => []);
      grouped[file]!.add(issue);
    }

    return grouped;
  }

  // ================================================================
  // CATEGORY COUNTS
  // ================================================================

  int categoryCount(String category) {
    return issues.where((issue) {
      if (issue is! Map) {
        return false;
      }

      return issue['category']
              ?.toString()
              .toUpperCase() ==
          category;
    }).length;
  }

  // ================================================================
  // COLORS
  // ================================================================

  Color severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return AppColors.critical;

      case 'HIGH':
        return AppColors.high;

      case 'MEDIUM':
        return AppColors.medium;

      case 'LOW':
        return AppColors.low;

      default:
        return AppColors.accent;
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.header,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================================
            // HEADER
            // ==========================================================

            Container(
              width: double.infinity,
              color: AppColors.header,

              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                24,
                24,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ----------------------------------------------------
                  // BACK + TITLE
                  // ----------------------------------------------------

                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,

                        decoration: BoxDecoration(
                          color: const Color(0xFFEAC7C4),
                          borderRadius:
                              BorderRadius.circular(11),
                        ),

                        child: IconButton(
                          padding: EdgeInsets.zero,

                          onPressed: () {
                            Navigator.pop(context);
                          },

                          icon: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color:
                                AppColors.primaryText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Review result',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color:
                              AppColors.primaryText,
                        ),
                      ),

                     

                     
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.repositoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================================
            // ROUNDED CONTENT
            // ==========================================================

            Expanded(
              child: Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: AppColors.background,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    32,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // =================================================
                      // SEVERITY SUMMARY CARD
                      // =================================================

                      _buildSeveritySummary(),

                      const SizedBox(height: 18),

                      // =================================================
                      // FILES + ISSUES
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              filesReviewed.toString(),
                              'Files reviewed',
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _statCard(
                              totalIssues.toString(),
                              'Total issues',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // =================================================
                      // FILTER
                      // =================================================

                      const Text(
                        'Filter by category',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color:
                              AppColors.primaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildCategoryFilters(),

                      const SizedBox(height: 20),

                      // =================================================
                      // ISSUES BY FILE
                      // =================================================

                      const Text(
                        'Issues by file',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              AppColors.primaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (groupedIssues.isEmpty)
                        _buildNoIssuesCard()
                      else
                        ...groupedIssues.entries.map(
                          (entry) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child:
                                  _buildFileGroup(
                                entry.key,
                                entry.value,
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 18),

                      // =================================================
                      // BOTTOM ACTIONS
                      // =================================================

                      _buildBottomActions(),
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

  // ================================================================
  // SEVERITY SUMMARY
  // ================================================================

  Widget _buildSeveritySummary() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          // ----------------------------------------------------------
          // DONUT
          // ----------------------------------------------------------

          SizedBox(
            width: 108,
            height: 108,

            child: CustomPaint(
              painter: SeverityDonutPainter(
                critical:
                    severityCount('CRITICAL'),
                high:
                    severityCount('HIGH'),
                medium:
                    severityCount('MEDIUM'),
                low:
                    severityCount('LOW'),
              ),

              child: Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    Text(
                      totalIssues.toString(),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors.primaryText,
                      ),
                    ),

                    const SizedBox(height: 1),

                    const Text(
                      'issues',
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ----------------------------------------------------------
          // SUMMARY
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  '$totalIssues issues',

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppColors.primaryText,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'across files reviewed',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 10),

                _severityLegend(
                  'High',
                  severityCount('HIGH'),
                  AppColors.high,
                ),

                const SizedBox(height: 5),

                _severityLegend(
                  'Medium',
                  severityCount('MEDIUM'),
                  AppColors.medium,
                ),

                const SizedBox(height: 5),

                _severityLegend(
                  'Low',
                  severityCount('LOW'),
                  AppColors.low,
                ),

                if (severityCount('CRITICAL') > 0) ...[
                  const SizedBox(height: 5),

                  _severityLegend(
                    'Critical',
                    severityCount('CRITICAL'),
                    AppColors.critical,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SEVERITY LEGEND
  // ================================================================

  Widget _severityLegend(
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            label,

            style: const TextStyle(
              fontSize: 11,
              color:
                  AppColors.secondaryText,
            ),
          ),
        ),

        Text(
          count.toString(),

          style: const TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w500,
            color:
                AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // STAT CARD
  // ================================================================

  Widget _statCard(
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(13),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            value,

            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.primaryText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,

            style: const TextStyle(
              fontSize: 11,
              color:
                  AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CATEGORY FILTERS
  // ================================================================

  Widget _buildCategoryFilters() {
    final categories = <String>[
      'ALL',
      'QUALITY',
      'BUG',
      'PERFORMANCE',
      'SECURITY',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children: categories.map(
        (category) {
          final selected =
              selectedCategory == category;

          final count =
              category == 'ALL'
                  ? totalIssues
                  : categoryCount(category);

          // Don't show categories that don't exist,
          // except ALL.
          if (category != 'ALL' && count == 0) {
            return const SizedBox.shrink();
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },

            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 7,
              ),

              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryText
                    : AppColors.white,

                border: Border.all(
                  color: selected
                      ? AppColors.primaryText
                      : AppColors.border,
                ),

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(
                '${_categoryLabel(category)} $count',

                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      selected
                          ? FontWeight.w500
                          : FontWeight.w400,

                  color: selected
                      ? Colors.white
                      : AppColors.secondaryText,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  String _categoryLabel(String category) {
    if (category == 'ALL') {
      return 'All';
    }

    return category[0] +
        category.substring(1).toLowerCase();
  }

  // ================================================================
  // FILE GROUP
  // ================================================================

  Widget _buildFileGroup(
    String fileName,
    List<dynamic> fileIssues,
  ) {
    final expanded =
        expandedFiles[fileName] ?? false;

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          // ----------------------------------------------------------
          // FILE HEADER
          // ----------------------------------------------------------

          InkWell(
            borderRadius:
                BorderRadius.circular(14),

            onTap: () {
              setState(() {
                expandedFiles[fileName] =
                    !expanded;
              });
            },

            child: Padding(
              padding:
                  const EdgeInsets.all(12),

              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFF6D7D2),

                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.description_outlined,
                      size: 18,
                      color:
                          AppColors.primaryText,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          _shortFileName(fileName),

                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w500,
                            color:
                                AppColors.primaryText,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          _filePath(fileName),

                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 10,
                            color:
                                AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.medium,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      fileIssues.length.toString(),

                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors.primaryText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    expanded
                        ? Icons
                            .keyboard_arrow_up_rounded
                        : Icons
                            .keyboard_arrow_down_rounded,

                    size: 19,

                    color:
                        AppColors.secondaryText,
                  ),
                ],
              ),
            ),
          ),

          // ----------------------------------------------------------
          // ISSUES
          // ----------------------------------------------------------

          if (expanded)
            ...fileIssues.map(
              (issue) {
                return _buildIssue(
                  issue,
                  isLast:
                      issue == fileIssues.last,
                );
              },
            ),
        ],
      ),
    );
  }

  // ================================================================
  // ISSUE
  // ================================================================

  Widget _buildIssue(
    dynamic issue, {
    required bool isLast,
  }) {
    if (issue is! Map) {
      return const SizedBox.shrink();
    }

    final severity =
        issue['severity']?.toString() ??
            'UNKNOWN';

    final category =
        issue['category']?.toString() ??
            'UNKNOWN';

    final description =
        issue['description']?.toString() ??
            'No description available.';

    final line =
        issue['line']?.toString() ??
            '';

    final recommendation =
        issue['recommendation']?.toString() ??
            '';

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        13,
      ),

      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------------------
          // SEVERITY + CATEGORY
          // ----------------------------------------------------------

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: severityColor(
                    severity,
                  ),

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Text(
                  severity,

                  style:
                      const TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppColors.primaryText,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                _categoryIcon(category),
                size: 13,
                color:
                    AppColors.secondaryText,
              ),

              const SizedBox(width: 4),

              Text(
                category,

                style:
                    const TextStyle(
                  fontSize: 11,
                  color:
                      AppColors.secondaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ----------------------------------------------------------
          // DESCRIPTION
          // ----------------------------------------------------------

          Text(
            description,

            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              fontWeight:
                  FontWeight.w500,
              color:
                  AppColors.primaryText,
            ),
          ),

          const SizedBox(height: 4),

          // ----------------------------------------------------------
          // LINE
          // ----------------------------------------------------------

          if (line.isNotEmpty)
            Text(
              'Line $line',

              style:
                  const TextStyle(
                fontSize: 10,
                color:
                    AppColors.secondaryText,
              ),
            ),

          // ----------------------------------------------------------
          // SUGGESTED FIX
          // ----------------------------------------------------------

          if (recommendation.isNotEmpty) ...[
            const SizedBox(height: 9),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(11),

              decoration: BoxDecoration(
                color:
                    const Color(0xFFF6EFED),

                borderRadius:
                    BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'SUGGESTED FIX',

                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w600,
                      letterSpacing: 0.4,
                      color:
                          AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    recommendation,

                    style:
                        const TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color:
                          AppColors.secondaryText,
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

  // ================================================================
  // NO ISSUES
  // ================================================================

  Widget _buildNoIssuesCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 22,
            color: AppColors.low,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'No issues were found for this filter.',
              style: TextStyle(
                fontSize: 13,
                color:
                    AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // BOTTOM ACTIONS
  // ================================================================

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Export later.
            },

            icon: const Icon(
              Icons.download_outlined,
              size: 17,
            ),

            label: const Text('Export'),

            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.primaryText,

              backgroundColor:
                  AppColors.white,

              side: const BorderSide(
                color: AppColors.border,
              ),

              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: const Icon(
              Icons.refresh_rounded,
              size: 17,
            ),

            label: const Text('Re-review'),

            style:
                ElevatedButton.styleFrom(
              foregroundColor:
                  Colors.white,

              backgroundColor:
                  AppColors.primaryText,

              elevation: 0,

              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // CATEGORY ICON
  // ================================================================

  IconData _categoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'BUG':
        return Icons.bug_report_outlined;

      case 'QUALITY':
        return Icons.code_rounded;

      case 'PERFORMANCE':
        return Icons.speed_rounded;

      case 'SECURITY':
        return Icons.security_outlined;

      default:
        return Icons.info_outline;
    }
  }

  // ================================================================
  // FILE HELPERS
  // ================================================================

  String _shortFileName(String path) {
    if (path.contains('/')) {
      return path.split('/').last;
    }

    if (path.contains('\\')) {
      return path.split('\\').last;
    }

    return path;
  }

  String _filePath(String path) {
    final name = _shortFileName(path);

    if (path == name) {
      return '';
    }

    final index = path.lastIndexOf(name);

    if (index > 0) {
      final parent = path.substring(
        0,
        index,
      );

      if (parent.length > 30) {
        return '...${parent.substring(parent.length - 27)}';
      }

      return parent;
    }

    return '';
  }
}

// ====================================================================
// DONUT CHART
// ====================================================================

class SeverityDonutPainter extends CustomPainter {
  final int critical;
  final int high;
  final int medium;
  final int low;

  SeverityDonutPainter({
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final total =
        critical + high + medium + low;

    if (total == 0) {
      return;
    }

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(
          size.width,
          size.height,
        ) /
        2;

    const strokeWidth = 11.0;

    final rect = Rect.fromCircle(
      center: center,
      radius:
          radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final values = [
      critical,
      high,
      medium,
      low,
    ];

    final colors = [
      AppColors.critical,
      AppColors.high,
      AppColors.medium,
      AppColors.low,
    ];

    double startAngle =
        -math.pi / 2;

    for (int i = 0;
        i < values.length;
        i++) {
      if (values[i] == 0) {
        continue;
      }

      final sweep =
          (values[i] / total) *
              2 *
              math.pi;

      paint.color = colors[i];

      canvas.drawArc(
        rect,
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(
    covariant SeverityDonutPainter oldDelegate,
  ) {
    return oldDelegate.critical != critical ||
        oldDelegate.high != high ||
        oldDelegate.medium != medium ||
        oldDelegate.low != low;
  }
}