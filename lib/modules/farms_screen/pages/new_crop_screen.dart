import 'dart:developer';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/new_Crop/new_crop_cubit.dart';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/modules/farms_screen/models/sowing/sowing.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter_platform_interface/src/types/polygon.dart';

class NewCropScreen extends StatefulWidget {
  const NewCropScreen({
    super.key,
    required this.farmName,
    required this.polygonImage,
    required this.selectedPolygon,
  });

  final String farmName;
  final Uint8List polygonImage;
  final Set<Polygon> selectedPolygon;

  @override
  State<NewCropScreen> createState() => _NewCropScreenState();
}

class _NewCropScreenState extends State<NewCropScreen> {
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
  final List<Sowing> sowing = [
    Sowing(AppStrings.sowingText, Assets.sowingIcon1, true, SowingEnum.sowing),
    Sowing(AppStrings.maintenance, Assets.sowingIcon1, false,
        SowingEnum.maintenance),
    Sowing(AppStrings.harvest, Assets.sowingIcon1, false, SowingEnum.harvest),
  ];
  List<String> tags = [];
  TextEditingController varitiesController = TextEditingController();
  TextEditingController cropNameController = TextEditingController();
  String cropName = '';
  SowingEnum selectedSowing = SowingEnum.sowing;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewCropCubit(),
      child:
          BlocConsumer<NewCropCubit, NewCropState>(listener: (context, state) {
        log("state: $state");
        if (state is NewCropLoadingState) {
          isLoading = true;
        } else if (state is NewCropSuccessState) {
          isLoading = false;
          Navigator.pop(context);
        } else if (state is NewCropFailedState) {
          isLoading = false;
          // Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                      CustomTextField(
                        name: AppStrings.cropName,
                        hintText: "Write name",
                        borderColor: const Color(0xFFD9D9D9),
                        onChange: (text) {
                          setState(() {
                            cropName = text;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: varitiesController,
                        name: AppStrings.varieties,
                        hintText: "Write here",
                        multiLine: false,
                        borderColor: const Color(0xFFD9D9D9),
                        onSubmitted: (text) {
                          setState(() {
                            tags.add(text);
                            varitiesController.text = '';
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (tags.isNotEmpty)
                        SizedBox(
                          height: 27,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: tags.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 10,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB72478),
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        tags[index],
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tags.removeAt(index);
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          Assets.closeBtn,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      else
                        const SizedBox(),
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
                              border: Border.all(
                                  color: const Color(0xFFD9D9D9), width: 2),
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
                              thumbVisibility:
                                  MaterialStateProperty.all<bool>(true),
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
                      CustomTextField(
                        name: AppStrings.seedTime,
                        hintText: "Select date",
                        borderColor: const Color(0xFFD9D9D9),
                        icon: Assets.calendarIcon,
                        iconOnLeft: false,
                        isCalendarPicker: true,
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
                        height: 119,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: sowing.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  for (int i = 0; i < sowing.length; i++) {
                                    if (i == index) {
                                      sowing[i].isSelected = true;
                                      selectedSowing = sowing[i].sowing;
                                    } else {
                                      sowing[i].isSelected = false;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 105,
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
                                  border: sowing[index].isSelected
                                      ? Border.all(
                                          color: AppColors.greenColor, width: 2)
                                      : Border.all(
                                          color: Colors.transparent, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      sowing[index].imagePath,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      sowing[index].name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGrey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: GestureDetector(
                          onTap: state is NewCropLoadingState
                              ? null
                              : () async {
                                  if (cropName.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please enter crop name',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                        backgroundColor: AppColors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (tags.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please enter varieties',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                        backgroundColor: AppColors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (selectedValue == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please select scientific name',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                            fontFamily: Assets.rubik,
                                          ),
                                        ),
                                        backgroundColor: AppColors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<NewCropCubit>().addNewCrop(
                                        widget.farmName,
                                        cropName,
                                        tags,
                                        selectedValue!,
                                        DateTime.now(),
                                        selectedSowing,
                                        widget.polygonImage,
                                      );
                                },
                          child: Container(
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
                              child: state is NewCropLoadingState
                                  ? const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : Text(
                                      AppStrings.keepText,
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
      }),
    );
  }
}
