import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/views/tags_view.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepFourNewFarmScreen extends StatefulWidget {
  const StepFourNewFarmScreen({super.key});

  @override
  State<StepFourNewFarmScreen> createState() => _StepFourNewFarmScreenState();
}

class _StepFourNewFarmScreenState extends State<StepFourNewFarmScreen> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  final List<String> sowingTextList = [
    AppStrings.sowingText,
    AppStrings.sowingText,
    AppStrings.sowingText,
  ];
  final List<String> iconList = [
    Assets.sowingIcon1,
    Assets.sowingIcon2,
    Assets.sowingIcon3,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.newCrop,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF24B763),
                          fontFamily: Assets.rubik,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF24B763),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTextField(
                    name: AppStrings.cropName,
                    hintText: "0000",
                    borderColor: Color(0xFFD9D9D9),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTextField(
                    name: AppStrings.cropName,
                    hintText: "0000",
                    borderColor: Color(0xFFD9D9D9),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: TagsView(
                      postTags: [
                        Tag("Clay", true),
                        Tag("Sandy", false),
                        Tag("Sandy", false),
                        Tag("Sandy", false),
                      ],
                      onTagTapped: (index) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTextField(
                    name: AppStrings.cropName,
                    hintText: "0000",
                    borderColor: Color(0xFFD9D9D9),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    AppStrings.scientificName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        AppStrings.searchScientificName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD9D9D9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD9D9D9), width: 2),
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 16,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // color: Colors.redAccent,
                        ),
                        offset: const Offset(0, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility: MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 50,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTextField(
                    name: AppStrings.cropName,
                    hintText: "0000",
                    borderColor: Color(0xFFD9D9D9),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    AppStrings.sowingStatus,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: iconList.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              color: AppColors.greenColor,
                              width: 2
                            ),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                iconList[index],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                sowingTextList[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const StepFourNewFarmScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 10,
                        ),
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.continueText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              fontFamily: Assets.rubik,
                            ),
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
      ),
    );
  }
}
