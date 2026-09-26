import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'review_result_screen.dart';
import '../services/api_service.dart';
class FileReviewScreen extends StatefulWidget {
  const FileReviewScreen({super.key});

  @override
  State<FileReviewScreen> createState() => _FileReviewScreenState();
}

class _FileReviewScreenState extends State<FileReviewScreen> {
  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const Color backgroundColor = Color(0xFFFFF5F5);
  static const Color headerColor = Color(0xFFF7D6D0);
  static const Color accentColor = Color(0xFFE2B4BD);

  static const Color primaryText = Color(0xFF2D2929);
  static const Color secondaryText = Color(0xFF7B6F6F);



  String? selectedFileName;
  String? selectedFileType;
  String? selectedFileSize;
  String? selectedFilePath;



  Future<void> _pickFile() async {
  try {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: [
        'py',
        'java',
        'kt',
        'js',
        'ts',
        'dart',
        'cpp',
        'c',
        'cs',
        'go',
        'rs',
        'swift',
      ],
    );

    if (file == null) {
      return;
    }

    if (file.path == null) {
      debugPrint('Selected file has no path');
      return;
    }

    final int? fileLength = file.lengthSync();

    setState(() {
      selectedFileName = file.name;
      selectedFileType = _getFileType(file.name);
      selectedFileSize = _formatFileSize(fileLength);
      selectedFilePath = file.path;
    });
  } catch (e) {
    debugPrint('File picker error: $e');
  }
}

String _getFileType(String fileName) {
  final parts = fileName.split('.');

  if (parts.length < 2) {
    return 'Source file';
  }

  final extension = parts.last.toLowerCase();

  switch (extension) {
    case 'py':
      return 'Python';

    case 'java':
      return 'Java';

    case 'kt':
      return 'Kotlin';

    case 'js':
      return 'JavaScript';

    case 'ts':
      return 'TypeScript';

    case 'dart':
      return 'Dart';

    case 'cpp':
      return 'C++';

    case 'c':
      return 'C';

    case 'cs':
      return 'C#';

    case 'go':
      return 'Go';

    case 'rs':
      return 'Rust';

    case 'swift':
      return 'Swift';

    default:
      return extension.toUpperCase();
  }
}

String _formatFileSize(int? bytes) {
  if (bytes == null) {
    return 'Unknown size';
  }

  if (bytes < 1024) {
    return '$bytes B';
  }

  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }

  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

Future<void> _reviewFile() async {
  if (selectedFilePath == null ||
      selectedFileName == null) {
    return;
  }

  try {
    final result = await ApiService.reviewFile(
      filePath: selectedFilePath!,
      fileName: selectedFileName!,
    );

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewResultScreen(
          result: result,
          fileName: selectedFileName!,
        ),
      ),
    );
  } catch (e) {
    debugPrint('File review failed: $e');

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'File review failed: $e',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerColor,

      body: SafeArea(
        child: Stack(
          children: [

            // =====================================================
            // HEADER
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

                  // ------------------------------------------------
                  // BACK BUTTON + TITLE
                  // ------------------------------------------------

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
                            color: primaryText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'File review',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ------------------------------------------------
                  // STEP
                  // ------------------------------------------------

                  const Padding(
                    padding: EdgeInsets.only(left: 1),

                    child: Text(
                      'Step 1 of 1',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // TITLE
                  // ------------------------------------------------

                  const Text(
                    'Review a single file',

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: primaryText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------

                  const Text(
                    'Upload a source file for a focused, line-by-line pass.',

                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // ROUNDED CONTENT PANEL
            // =====================================================

            Positioned(
              top: 213,
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

                      // =================================================
                      // SOURCE FILE LABEL
                      // =================================================

                      const Text(
                        'Source file',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // =================================================
                      // FILE UPLOAD AREA
                      // =================================================

                      GestureDetector(
                        onTap: _pickFile,

                        child: Container(
                          width: double.infinity,
                          height: 205,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(17),

                            border: Border.all(
                              color: accentColor,
                              width: 1,
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              // ------------------------------------------------
                              // FILE ICON
                              // ------------------------------------------------

                              Container(
                                width: 50,
                                height: 50,

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xFFF7D6D0,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    13,
                                  ),
                                ),

                                child: const Icon(
                                  Icons
                                      .upload_file_outlined,
                                  size: 25,
                                  color:
                                      Color(0xFF805B60),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ------------------------------------------------
                              // CHOOSE FILE
                              // ------------------------------------------------

                              const Text(
                                'Choose a file',

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500,
                                  color: primaryText,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                'or drag and drop here',

                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(0xFFA48686),
                                ),
                              ),

                              const SizedBox(height: 13),

                              // ------------------------------------------------
                              // FILE TYPE CHIPS
                              // ------------------------------------------------

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [

                                  _FileTypeChip(
                                    label: '.py',
                                  ),

                                  const SizedBox(width: 6),

                                  _FileTypeChip(
                                    label: '.java',
                                  ),

                                  const SizedBox(width: 6),

                                  _FileTypeChip(
                                    label: '.kt',
                                  ),

                                  const SizedBox(width: 6),

                                  _FileTypeChip(
                                    label: '.js',
                                  ),

                                  const SizedBox(width: 6),

                                  _FileTypeChip(
                                    label: '.ts',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // SELECTED FILE
                      // =================================================

                      const Text(
                        'Selected file',

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // =================================================
                      // SELECTED FILE CARD
                      // =================================================

                      if (selectedFileName != null)
                        _SelectedFileCard(
                          fileName:
                              selectedFileName!,
                          fileType:
                              selectedFileType ??
                                  'Source file',
                          fileSize:
                              selectedFileSize ??
                                  '',
                          onRemove: () {
                            setState(() {
                              selectedFileName = null;
                              selectedFileType = null;
                              selectedFileSize = null;
                              selectedFilePath = null;
                            });
                          },
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 70,

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

                          child: const Center(
                            child: Text(
                              'No file selected',

                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    Color(0xFFB4A5A5),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 26),

                      // =================================================
                      // REVIEW BUTTON
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child: ElevatedButton.icon(

                         onPressed:
                          selectedFilePath == null
                              ? null
                              : _reviewFile,

                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            size: 21,
                          ),

                          label: const Text(
                            'Review file',

                            style: TextStyle(
                              fontSize: 15,
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

// ================================================================
// FILE TYPE CHIP
// ================================================================

class _FileTypeChip extends StatelessWidget {
  final String label;

  const _FileTypeChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFF1E9E8),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Text(
        label,

        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF8A7777),
        ),
      ),
    );
  }
}

// ================================================================
// SELECTED FILE CARD
// ================================================================

class _SelectedFileCard extends StatelessWidget {
  final String fileName;
  final String fileType;
  final String fileSize;
  final VoidCallback onRemove;

  const _SelectedFileCard({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: const Color(0xFFE8DCDC),
        ),
      ),

      child: Row(
        children: [

          // ----------------------------------------------------------
          // FILE ICON
          // ----------------------------------------------------------

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: const Color(0xFFF7D6D0),

              borderRadius:
                  BorderRadius.circular(11),
            ),

            child: const Icon(
              Icons.description_outlined,
              size: 21,
              color: Color(0xFF805B60),
            ),
          ),

          const SizedBox(width: 12),

          // ----------------------------------------------------------
          // FILE INFORMATION
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  fileName,

                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w500,
                    color: Color(0xFF302929),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$fileType • $fileSize',

                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA48686),
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------
          // REMOVE BUTTON
          // ----------------------------------------------------------

          GestureDetector(
            onTap: onRemove,

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: const Color(0xFFF1E9E8),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.close,
                size: 17,
                color: Color(0xFF8A7777),
              ),
            ),
          ),
        ],
      ),
    );
  }
}