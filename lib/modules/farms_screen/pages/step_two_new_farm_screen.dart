import 'dart:developer';
import 'dart:typed_data';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/farms/farm_cubit.dart';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/modules/farms_screen/pages/crops_list.dart';
import 'package:finca/modules/farms_screen/pages/step_three_new_farm_screen.dart';
import 'package:finca/views/tags_view.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class StepTwoNewFarmScreen extends StatefulWidget {
  final List<LatLng> selectedPolygons;
  final Uint8List polygonImage;
  final bool? isUpdating;
  final FarmModel? farm;

  const StepTwoNewFarmScreen(
      {super.key, this.isUpdating = false, this.farm, required this.selectedPolygons, required this.polygonImage});

  @override
  State<StepTwoNewFarmScreen> createState() => _StepTwoNewFarmScreenState();
}

class _StepTwoNewFarmScreenState extends State<StepTwoNewFarmScreen> {
  String farmName = '';
  String size = '';
  Tag selectedSoilType = Tag("", true);
  String? description;
  bool isLoading = false;
  List<Tag> soilTypes = [];
  TextEditingController? nameController;
  TextEditingController sizeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return FarmCubit()..getSoiType();
      },
      child: BlocConsumer<FarmCubit, FarmsState>(listener: (context, state) async {
        if (state is SoilLoadingState) {
          isLoading = true;
        } else if (state is SoilSuccessState) {
          soilTypes = state.soilTypes;
          if (widget.isUpdating ?? false) {
            nameController = TextEditingController(text: widget.farm?.farmName ?? '');
            farmName = widget.farm?.farmName ?? '';
            sizeController = TextEditingController(text: widget.farm?.size.toString() ?? 0.0.toString());
            size = widget.farm?.size.toString() ?? 0.0.toString();
            descriptionController = TextEditingController(text: widget.farm?.description ?? '');
            description = widget.farm?.description;
            for (int i = 0; i < soilTypes.length; i++) {
              if (soilTypes[i].name == widget.farm?.soilType) {
                soilTypes[i].isSelected = true;
                selectedSoilType = soilTypes[i];
              }
            }
          }
          isLoading = false;
        } else if (state is SoilFailedState) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 7,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            10,
                          ),
                          bottomRight: Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                SvgPicture.asset(Assets.backIcon),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (widget.isUpdating ?? false) ? AppStrings.editFarm : AppStrings.newFarm,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.greenColor,
                                  fontFamily: Assets.rubik,
                                ),
                              ),
                              Text(
                                AppStrings.stepTwo,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGrey,
                                  fontFamily: Assets.rubik,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25,
                        right: 10,
                      ),
                      child: CustomTextField(
                        name: AppStrings.name,
                        hintText: "Write name",
                        controller: nameController,
                        onChange: (text) {
                          setState(() {
                            farmName = text;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25,
                        right: 10,
                      ),
                      child: CustomTextField(
                        name: AppStrings.size,
                        hintText: "0000",
                        controller: sizeController,
                        isNumberTextField: true,
                        onChange: (text) {
                          setState(() {
                            size = text;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.soilType,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              fontFamily: Assets.rubik,
                            ),
                          ),
                          if (soilTypes.isNotEmpty) ...{
                            TagsView(
                              postTags: soilTypes,
                              onTagTapped: (index) {
                                for (int i = 0; i < soilTypes.length; i++) {
                                  if (i == index) {
                                    soilTypes[i].isSelected = true;
                                  } else {
                                    soilTypes[i].isSelected = false;
                                  }
                                }
                                log('selectedSoilType: ${soilTypes.toString()}');
                                selectedSoilType = soilTypes[index];
                                setState(() {});
                              },
                            )
                          } else ...{
                            const SizedBox(
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 25,
                        right: 10,
                      ),
                      child: CustomTextField(
                        name: AppStrings.stepTwoNewFarmDescription,
                        hintText: "Write additional description",
                        controller: descriptionController,
                        onChange: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (farmName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Por favor, ingresa el nombre de la finca'),
                          ));
                          return;
                        }
                        if (selectedSoilType.name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Por favor seleccione el tipo de suelo'),
                          ));
                          return;
                        }
                        if (size.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Por favor, ingresa el tamaño de la finca'),
                          ));
                          return;
                        }
                        if (widget.isUpdating ?? false) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CropsList(
                                isUpdating: widget.isUpdating,
                                farm: widget.farm,
                                farmName: farmName ?? '',
                                size: size,
                                selectedSoilType: selectedSoilType,
                                description: description,
                                selectedPolygons: widget.selectedPolygons,
                                polygonImage: widget.polygonImage,
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StepThreeNewFarmScreen(
                                farm: widget.farm,
                                farmName: farmName,
                                size: size,
                                selectedSoilType: selectedSoilType,
                                description: description,
                                selectedPolygons: widget.selectedPolygons,
                                polygonImage: widget.polygonImage,
                              ),
                            ),
                          );
                        }
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
                            10,
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
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class StepTwoTagsView extends StatelessWidget {
  const StepTwoTagsView({
    super.key,
    required this.postTags,
    required this.onTagTapped,
  });

  final List<Tag> postTags;
  final Function(int index) onTagTapped;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
    );
  }
}
