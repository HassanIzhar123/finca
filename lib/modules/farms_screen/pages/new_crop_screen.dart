import 'dart:developer';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/new_Crop/new_crop_cubit.dart';
import 'package:finca/cubits/new_Crop/new_crop_state.dart';
import 'package:finca/enums/sowing_enum.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/sowing/sowing.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class NewCropScreen extends StatefulWidget {
  const NewCropScreen({
    super.key,
    this.isUpdating = false,
    this.farm,
    this.crop,
    required this.farmName,
    required this.polygonImage,
    required this.selectedPolygon,
  });

  final Crop? crop;
  final FarmModel? farm;
  final bool isUpdating;
  final String farmName;
  final Uint8List polygonImage;
  final List<LatLng> selectedPolygon;

  @override
  State<NewCropScreen> createState() => _NewCropScreenState();
}

class _NewCropScreenState extends State<NewCropScreen> {
  List<String> varieties = [];
  List<Tag> databaseCropNames = [];
  List<String> selectedVariety = [];
  final List<Sowing> sowing = [
    Sowing(AppStrings.sowingText, Assets.sowingIcon1, true, SowingEnum.sowing),
    Sowing(AppStrings.maintenance, Assets.sowingIcon1, false, SowingEnum.maintenance),
    Sowing(AppStrings.harvest, Assets.sowingIcon1, false, SowingEnum.harvest),
  ];
  List<String> selectedCropNames = [];
  TextEditingController varietiesController = TextEditingController();
  TextEditingController cropNameController = TextEditingController();
  SowingEnum selectedSowing = SowingEnum.sowing;
  DateTime seedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final NewCropCubit newCropCubit = NewCropCubit();
        newCropCubit.setIfUpdating(widget.isUpdating);
        newCropCubit.getScientificNames();
        newCropCubit.getVarieties();
        return newCropCubit;
      },
      child: BlocConsumer<NewCropCubit, NewCropState>(listener: (context, state) {
        log("state: $state");
        if (state is InitialCropData) {
          selectedCropNames.addAll(widget.crop?.cropNames ?? []);
          selectedSowing = widget.crop?.sowing ?? SowingEnum.sowing;
          seedTime = widget.crop?.seedTime ?? DateTime.now();
          log('seedTime: $seedTime');
          for (var element in sowing) {
            if (element.sowing == selectedSowing) {
              element.isSelected = true;
            } else {
              element.isSelected = false;
            }
          }
        } else if (state is NewCropLoadingState) {
        } else if (state is NewCropSuccessState) {
          Navigator.pop(context, true);
        } else if (state is NewCropFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UpdateCropLoadingState) {
        } else if (state is UpdateCropSuccessState) {
          Navigator.pop(context, false);
        } else if (state is UpdateCropFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is VarietiesLoadingState) {
          varieties.clear();
        } else if (state is VarietiesSuccessState) {
          varieties = state.varieties;
          varieties.sort();
          log('varietiesNames: ${varieties.toString()}');
          selectedVariety.addAll(widget.crop?.varieties ?? []);
        } else if (state is VarietiesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is CropNamesLoadingState) {
          databaseCropNames.clear();
        } else if (state is CropNamesSuccessState) {
          databaseCropNames = state.cropNames;
          databaseCropNames.sort((a, b) => a.name.compareTo(b.name));
          log('cropNames: $databaseCropNames');
        } else if (state is CropNamesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return state is NewCropLoadingState || state is UpdateCropLoadingState ? false : true;
          },
          child: Scaffold(
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
                              (widget.isUpdating ?? false) ? AppStrings.editCrop : AppStrings.newCrop,
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
                        const Text(
                          AppStrings.cropName,
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
                          child: DropdownButton2<Tag>(
                            isExpanded: true,
                            hint: const Text(
                              AppStrings.cropName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD9D9D9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: databaseCropNames
                                .map(
                                  (Tag item) => DropdownMenuItem<Tag>(
                                    value: item,
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            value: getSelectedCropName(databaseCropNames),
                            onChanged: (Tag? value) {
                              setState(() {
                                selectedCropNames.add(value!.name);
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
                        if (selectedCropNames.isNotEmpty)
                          SizedBox(
                            height: 27,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: selectedCropNames.length,
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
                                          selectedCropNames[index],
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
                                              selectedCropNames.removeAt(index);
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
                          // AppStrings.scientificName,
                          AppStrings.variety,
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
                              AppStrings.variety,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD9D9D9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: varieties
                                .map(
                                  (String item) => DropdownMenuItem<String>(
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
                                  ),
                                )
                                .toList(),
                            value: getSelectedVariety(varieties),
                            onChanged: (String? value) {
                              setState(() {
                                selectedVariety.add(value ?? '');
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
                        if (selectedVariety.isNotEmpty)
                          SizedBox(
                            height: 27,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: selectedVariety.length,
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
                                          selectedVariety[index],
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
                                              selectedVariety.removeAt(index);
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
                        CustomTextField(
                          name: AppStrings.seedTime,
                          hintText: "Select date",
                          borderColor: const Color(0xFFD9D9D9),
                          icon: Assets.calendarIcon,
                          iconOnLeft: false,
                          isCalendarPicker: true,
                          initialSelectedDate: seedTime,
                          onDateSelected: (DateTime date) {
                            log('date: $date');
                            seedTime = date;
                          },
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
                                        ? Border.all(color: AppColors.greenColor, width: 2)
                                        : Border.all(color: Colors.transparent, width: 2),
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
                            onTap: state is NewCropLoadingState || state is UpdateCropLoadingState
                                ? null
                                : () async {
                                    if (selectedCropNames.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Por favor ingrese cualquier nombre de cultivo',
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
                                    if (selectedVariety.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Por favor seleccione variedad',
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
                                    if (!widget.isUpdating) {
                                      context.read<NewCropCubit>().addNewCrop(
                                            widget.farmName,
                                            selectedCropNames,
                                            selectedVariety,
                                            DateTime.now(),
                                            selectedSowing,
                                            widget.polygonImage,
                                          );
                                    } else {
                                      context.read<NewCropCubit>().updateCrop(
                                            widget.crop?.cropId ?? '',
                                            widget.crop?.farmName ?? '',
                                            selectedCropNames,
                                            selectedVariety,
                                            seedTime,
                                            selectedSowing,
                                            widget.polygonImage,
                                          );
                                    }
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
                                child: state is NewCropLoadingState || state is UpdateCropLoadingState
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
          ),
        );
      }),
    );
  }

  Tag? getSelectedCropName(List<Tag> databaseCropNames) {
    int index = databaseCropNames.indexWhere((element) {
      return element.isSelected == true;
    });
    if (index != -1) {
      return databaseCropNames[index];
    }
    return null;
  }

  String? getSelectedVariety(List<String> varieties) {
    int index = varieties.indexWhere((element) {
      return element == selectedVariety;
    });
    if (index != -1) {
      return varieties[index];
    }
    return null;
  }
}
