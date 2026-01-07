import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class StepEntryModalWidget extends StatefulWidget {
  final Future<void> Function(int steps) onStepsAdded;

  const StepEntryModalWidget({
    super.key,
    required this.onStepsAdded,
  });

  @override
  State<StepEntryModalWidget> createState() => _StepEntryModalWidgetState();
}

class _StepEntryModalWidgetState extends State<StepEntryModalWidget>
    with TickerProviderStateMixin {
  final TextEditingController _stepsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, _slideAnimation.value * MediaQuery.of(context).size.height),
          child: Container(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 2.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'add_circle',
                      color: theme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Add Manual Steps',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Health permissions unavailable. Add your steps manually to keep your progress updated.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3.h),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of Steps',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _stepsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter steps (e.g., 2500)',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'directions_walk',
                              color: theme.colorScheme.primary,
                              size: 5.w,
                            ),
                          ),
                          suffixIcon: _stepsController.text.isNotEmpty
                              ? IconButton(
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 5.w,
                                  ),
                                  onPressed: () {
                                    _stepsController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of steps';
                          }
                          final steps = int.tryParse(value);
                          if (steps == null || steps <= 0) {
                            return 'Please enter a valid number of steps';
                          }
                          if (steps > 100000) {
                            return 'Steps cannot exceed 100,000';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          _buildQuickAddButton(context, '1,000'),
                          SizedBox(width: 2.w),
                          _buildQuickAddButton(context, '2,500'),
                          SizedBox(width: 2.w),
                          _buildQuickAddButton(context, '5,000'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _addSteps,
                        child: _isLoading
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text('Add Steps'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAddButton(BuildContext context, String steps) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _stepsController.text = steps.replaceAll(',', '');
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            steps,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _addSteps() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    final steps = int.parse(_stepsController.text);

    // Add haptic feedback
    HapticFeedback.lightImpact();

    await widget.onStepsAdded(steps);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Added ${steps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} steps successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
