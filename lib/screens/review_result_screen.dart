
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFF5F5);
  static const Color header = Color(0xFFF7D6D0);
  static const Color accent = Color(0xFFE2B4BD);

  static const Color primaryText = Color(0xFF2D2929);
  static const Color secondaryText = Color(0xFF7B6F6F);

  static const Color border = Color(0xFFE8D4D1);
  static const Color white = Colors.white;

  // Severity colors
  static const Color critical = Color(0xFFE98B8B);
  static const Color high = Color(0xFFF2A76F);
  static const Color medium = Color(0xFFF2C46D);
  static const Color low = Color(0xFF9ADBC9);
}

class ReviewResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final String fileName;

  const ReviewResultScreen({
    super.key,
    required this.result,
    required this.fileName,
  });

  @override
  State<ReviewResultScreen> createState() =>
      _ReviewResultScreenState();
}

class _ReviewResultScreenState
    extends State<ReviewResultScreen> {

  // Keeps track of which issue cards are expanded.
  final Map<int, bool> _expandedIssues = {};

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------

  List<dynamic> get issues {
    final value = widget.result['issues'];

    if (value is List) {
      return value;
    }

    return [];
  }

  List<dynamic> get testingRecommendations {
    final value =
        widget.result['testing_recommendations'];

    if (value is List) {
      return value;
    }

    return [];
  }

  String get summary {
    return widget.result['summary']?.toString() ??
        'No summary available.';
  }

  String get overallSeverity {
    return widget.result['overall_severity']
            ?.toString() ??
        'UNKNOWN';
  }

  // ------------------------------------------------------------
  // SEVERITY
  // ------------------------------------------------------------

  int severityCount(String severity) {
    return issues.where((issue) {
      if (issue is! Map) return false;

      return issue['severity']
              ?.toString()
              .toUpperCase() ==
          severity.toUpperCase();
    }).length;
  }

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

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.header,

      body: SafeArea(
        child: Column(
          children: [

            // ====================================================
            // HEADER
            // ====================================================

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

                  // ----------------------------------------------
                  // BACK BUTTON + TITLE
                  // ----------------------------------------------

                  Row(
                    children: [

                      Container(
                        width: 38,
                        height: 38,

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFEAC7C4),
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
                          fontWeight:
                              FontWeight.w500,
                          color:
                              AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ----------------------------------------------
                  // FILE / REPOSITORY NAME
                  // ----------------------------------------------

                  Text(
                    _getTitle(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ====================================================
            // ROUNDED CONTENT PANEL
            // ====================================================

            Expanded(
              child: Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: AppColors.background,

                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(30),
                    topRight:
                        Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    24,
                    20,
                    32,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ==================================================
                      // OVERALL SEVERITY BANNER
                      // ==================================================

                      _buildSeverityBanner(),

                      const SizedBox(height: 18),

                      // ==================================================
                      // SUMMARY
                      // ==================================================

                      Text(
                        summary,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.55,
                          color:
                              AppColors.secondaryText,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // SEVERITY COUNTERS
                      // ==================================================

                      _buildSeverityCounters(),

                      const SizedBox(height: 22),

                      // ==================================================
                      // ISSUES LABEL
                      // ==================================================

                      const Text(
                        'Issues found',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                          color:
                              AppColors.primaryText,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // ISSUE CARDS
                      // ==================================================

                      if (issues.isEmpty)
                        _buildNoIssuesCard()
                      else
                        ...issues.asMap().entries.map(
                          (entry) {
                            final index =
                                entry.key;
                            final issue =
                                entry.value;

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 10,
                              ),

                              child:
                                  _buildIssueCard(
                                issue,
                                index,
                              ),
                            );
                          },
                        ),

                      // ==================================================
                      // TESTING RECOMMENDATIONS
                      // ==================================================

                      if (testingRecommendations
                          .isNotEmpty) ...[
                        const SizedBox(height: 14),

                        const Text(
                          'Testing recommendations',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w500,
                            color:
                                AppColors.primaryText,
                          ),
                        ),

                        const SizedBox(height: 12),

                        _buildTestingCard(),
                      ],

                      const SizedBox(height: 24),

                      // ==================================================
                      // BOTTOM ACTIONS
                      // ==================================================

                      _buildBottomActions(context),
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
  // TITLE
  // ================================================================

  String _getTitle() {
    return widget.fileName;
  }

  // ================================================================
  // SEVERITY BANNER
  // ================================================================

  Widget _buildSeverityBanner() {
    final severity =
        overallSeverity.toUpperCase();

    IconData icon;

    switch (severity) {
      case 'CRITICAL':
        icon = Icons.warning_rounded;
        break;

      case 'HIGH':
        icon = Icons.error_outline_rounded;
        break;

      case 'MEDIUM':
        icon =
            Icons.warning_amber_rounded;
        break;

      default:
        icon =
            Icons.check_circle_outline_rounded;
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: severityColor(severity)
            .withValues(alpha: 0.18),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color:
                  severityColor(severity),
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color:
                  AppColors.primaryText,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                '$severity severity',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.primaryText,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '${issues.length} issue${issues.length == 1 ? '' : 's'} found',
                style: const TextStyle(
                  fontSize: 12,
                  color:
                      AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SEVERITY COUNTERS
  // ================================================================

  Widget _buildSeverityCounters() {
    return Row(
      children: [

        Expanded(
          child: _severityCounter(
            'CRITICAL',
            severityCount('CRITICAL'),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _severityCounter(
            'HIGH',
            severityCount('HIGH'),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _severityCounter(
            'MEDIUM',
            severityCount('MEDIUM'),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: _severityCounter(
            'LOW',
            severityCount('LOW'),
          ),
        ),
      ],
    );
  }

  Widget _severityCounter(
    String severity,
    int count,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),

      decoration: BoxDecoration(
        color: AppColors.white,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(
        children: [

          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.primaryText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            severity,
            style: const TextStyle(
              fontSize: 9,
              fontWeight:
                  FontWeight.w500,
              color:
                  AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ISSUE CARD
  // ================================================================

  Widget _buildIssueCard(
    dynamic issue,
    int index,
  ) {
    if (issue is! Map) {
      return const SizedBox.shrink();
    }

    final severity =
        issue['severity']?.toString() ??
            'UNKNOWN';

    final category =
        issue['category']?.toString() ??
            'UNKNOWN';

    final file =
        issue['file']?.toString() ?? '';

    final line =
        issue['line']?.toString() ?? '';

    final description =
        issue['description']?.toString() ??
            'No description available.';

    final recommendation =
        issue['recommendation']?.toString() ??
            '';

    // ------------------------------------------------------------
    // DEFAULT STATE
    // ------------------------------------------------------------
    //
    // CRITICAL + HIGH = expanded
    // MEDIUM + LOW = collapsed
    //

    final bool defaultExpanded =
        severity.toUpperCase() == 'CRITICAL' ||
        severity.toUpperCase() == 'HIGH';

    final bool isExpanded =
        _expandedIssues[index] ??
            defaultExpanded;

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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ========================================================
          // CLICKABLE HEADER
          // ========================================================

          InkWell(
            borderRadius:
                BorderRadius.circular(14),

            onTap: () {
              setState(() {
                _expandedIssues[index] =
                    !isExpanded;
              });
            },

            child: Padding(
              padding:
                  const EdgeInsets.all(14),

              child: Row(
                children: [

                  // ------------------------------------------------
                  // SEVERITY
                  // ------------------------------------------------

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: severityColor(
                        severity,
                      ).withValues(
                        alpha: 0.8,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(20),
                    ),

                    child: Text(
                      severity,
                      style:
                          const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors
                                .primaryText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ------------------------------------------------
                  // CATEGORY ICON
                  // ------------------------------------------------

                  Icon(
                    _categoryIcon(
                      category,
                    ),
                    size: 13,
                    color:
                        AppColors
                            .secondaryText,
                  ),

                  const SizedBox(width: 4),

                  // ------------------------------------------------
                  // CATEGORY
                  // ------------------------------------------------

                  Expanded(
                    child: Text(
                      category,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 11,
                        color:
                            AppColors
                                .secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ------------------------------------------------
                  // ARROW
                  // ------------------------------------------------

                  AnimatedRotation(
                    turns:
                        isExpanded
                            ? 0.5
                            : 0,

                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),

                    child: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      size: 20,
                      color:
                          AppColors
                              .secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ========================================================
          // EXPANDED CONTENT
          // ========================================================

          AnimatedCrossFade(
            duration:
                const Duration(
              milliseconds: 200,
            ),

            crossFadeState:
                isExpanded
                    ? CrossFadeState
                        .showFirst
                    : CrossFadeState
                        .showSecond,

            firstChild: Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                14,
                0,
                14,
                14,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Divider(
                    height: 1,
                    color:
                        AppColors.border,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ----------------------------------------------
                  // DESCRIPTION
                  // ----------------------------------------------

                  Text(
                    description,
                    style:
                        const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight:
                          FontWeight.w500,
                      color:
                          AppColors
                              .primaryText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // ----------------------------------------------
                  // FILE + LINE
                  // ----------------------------------------------

                  if (file.isNotEmpty)
                    Text(
                      '$file${line.isNotEmpty ? ':$line' : ''}',
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 11,
                        color:
                            AppColors
                                .secondaryText,
                      ),
                    ),

                  // ----------------------------------------------
                  // RECOMMENDATION
                  // ----------------------------------------------

                  if (recommendation
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 12,
                    ),

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .all(10),

                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .background,

                        borderRadius:
                            BorderRadius
                                .circular(
                          10,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Text(
                            'Recommendation',
                            style:
                                TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight
                                      .w600,
                              color:
                                  AppColors
                                      .primaryText,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            recommendation,
                            style:
                                const TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color:
                                  AppColors
                                      .secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            secondChild:
                const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TESTING RECOMMENDATIONS
  // ================================================================

  Widget _buildTestingCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.background,

        border: Border.all(
          color: AppColors.border,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: const [

              Icon(
                Icons.assignment_outlined,
                size: 17,
                color:
                    AppColors.primaryText,
              ),

              SizedBox(width: 8),

              Text(
                'Before you ship',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.primaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...testingRecommendations.map(
            (recommendation) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 10,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            AppColors
                                .secondaryText,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        recommendation
                            .toString(),

                        style:
                            const TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color:
                              AppColors
                                  .secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
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

      child: const Row(
        children: [

          Icon(
            Icons.check_circle_outline,
            color: AppColors.low,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'No issues were found in this review.',
              style: TextStyle(
                fontSize: 13,
                color:
                    AppColors
                        .secondaryText,
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

  Widget _buildBottomActions(
    BuildContext context,
  ) {
    return Row(
      children: [

        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Export will be implemented later.
            },

            icon: const Icon(
              Icons.download_outlined,
              size: 17,
            ),

            label:
                const Text('Export'),

            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.primaryText,

              backgroundColor:
                  AppColors.white,

              side:
                  const BorderSide(
                color:
                    AppColors.border,
              ),

              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 14,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
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

            label:
                const Text('Re-review'),

            style:
                ElevatedButton.styleFrom(
              foregroundColor:
                  Colors.white,

              backgroundColor:
                  AppColors.primaryText,

              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 14,
              ),

              elevation: 0,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
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

  IconData _categoryIcon(
    String category,
  ) {
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
}

