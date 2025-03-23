import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

import 'base/base_widget.dart';

class TutorialDialog extends BaseStatelessWidget {
  const TutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: 550,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  appLocalizations(context).tutorialTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.iconIconColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildTutorialStep(
                appLocalizations(context).tutorialStep1Title,
                appLocalizations(context).tutorialStep1Desc,
              ),
              _buildTutorialStep(
                appLocalizations(context).tutorialStep2Title,
                appLocalizations(context).tutorialStep2Desc,
              ),
              _buildTutorialStep(
                appLocalizations(context).tutorialStep3Title,
                appLocalizations(context).tutorialStep3Desc,
              ),
              _buildTutorialStep(
                appLocalizations(context).tutorialStep4Title,
                appLocalizations(context).tutorialStep4Desc,
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    appLocalizations(context).gotIt,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.iconTextColor,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
