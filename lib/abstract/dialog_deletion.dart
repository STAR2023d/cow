//  Stateful Engine managing Verification Steps & Progress Feedback

import 'package:cow/theme/app_theme.dart';
import 'package:cow/database/app_database.dart';
import 'package:flutter/material.dart';

class TwoStepDeleteWorkflow extends StatefulWidget {
  final CowData cow;
  final Future<void> Function() onConfirmedDelete;

  const TwoStepDeleteWorkflow({
    super.key,
    required this.cow,
    required this.onConfirmedDelete,
  });

  @override
  State<TwoStepDeleteWorkflow> createState() => _TwoStepDeleteWorkflowState();
}

class _TwoStepDeleteWorkflowState extends State<TwoStepDeleteWorkflow> {
  int _currentStep =
      1; // 1: Initial Warning, 2: Final Lockout Warning, 3: Executing Progress
  double _progressValue = 0.0;
  String _progressMessage = '';
  bool _isSuccess = false;

  void _advanceToStepTwo() {
    setState(() => _currentStep = 2);
  }

  void _beginExecution() async {
    setState(() {
      _currentStep = 3;
      _progressMessage = 'Preparing secure deletion routine...';
    });

    // Step A Timeline update
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _progressValue = 0.4;
      _progressMessage = 'Unlinking database references...';
    });

    // Step B Timeline update
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _progressValue = 0.75;
      _progressMessage = 'Expunging physical records from SQLite...';
    });

    // Execute actual background database deletion
    await widget.onConfirmedDelete();

    // Final completion screen mapping
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _progressValue = 1.0;
      _progressMessage = 'Record completely permanently removed.';
      _isSuccess = true;
    });

    // Clean exit
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(20),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: _buildCurrentStageView(),
      ),
    );
  }

  Widget _buildCurrentStageView() {
    switch (_currentStep) {
      case 1:
        // Verification Step 1: Standard Intent Check
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: context.farm.warning,
              size: 54,
            ),
            const SizedBox(height: 16),
            const Text(
              'Remove Cow Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete ${widget.cow.name} from the herd listing?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: context.farm.muted),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _advanceToStepTwo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.farm.warning,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        );

      case 2:
        // Verification Step 2: Absolute Lockout Warning (No Undo Emphasis)
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.report_problem_rounded,
              color: context.farm.danger,
              size: 54,
            ),
            const SizedBox(height: 16),
            Text(
              'Irreversible Deletion!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.farm.danger,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 14),
                children: [
                  const TextSpan(
                    text: 'This action is permanent and cannot be undone. ',
                  ),
                  TextSpan(text: 'All records associated with '),
                  //  CORRECT (Linter satisfied)
                  TextSpan(
                    text: widget.cow.name.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: context.farm.muted),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _beginExecution,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.farm.danger,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Delete Permanently'),
                ),
              ],
            ),
          ],
        );

      case 3:
        // Execution Stage: Show Progress Feedback
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isSuccess) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: _progressValue),
              const SizedBox(height: 12),
              Text(
                _progressMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ] else ...[
              Icon(
                Icons.check_circle_outline,
                color: context.farm.good,
                size: 56,
              ),
              const SizedBox(height: 12),
              const Text(
                'Deletion complete',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
