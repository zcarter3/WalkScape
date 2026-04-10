import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomErrorWidget({
    super.key,
    this.errorDetails,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sad_face.svg',
                  height: 42,
                  width: 42,
                ),
                const SizedBox(height: 8),
                Text(
                  "Something went wrong",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  child: Text(
                    errorMessage ??
                        errorDetails?.exceptionAsString() ??
                        'We encountered an unexpected error while processing your request.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                if (errorDetails?.stack != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        errorDetails!.stack.toString(),
                        style: TextStyle(fontSize: 10, color: theme.colorScheme.error),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    bool canBeBack = Navigator.canPop(context);
                    if (canBeBack) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pushNamed(context, '/');
                    }
                  },
                  icon: Icon(Icons.arrow_back, size: 18, color: theme.colorScheme.onPrimary),
                  label: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
