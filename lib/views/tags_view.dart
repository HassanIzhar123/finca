import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagsView extends StatelessWidget {
  const TagsView({
    super.key,

    required this.postTags,
    required this.onTagTapped,
  });

  // final double height, width;
  final List<Tag> postTags;
  final Function(int index) onTagTapped;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 0; i < postTags.length; i++) ...{
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              onTagTapped(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(
                right: 10,
              ),
              decoration: BoxDecoration(
                color: (postTags[i].isSelected) ? AppColors.purple : AppColors.creamColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              height: 32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    postTags[i].name,
                    style: TextStyle(
                      color: (postTags[i].isSelected) ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        },
      ],
    );
  }
}
