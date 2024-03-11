import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/farms/farm_cubit.dart';
import 'package:finca/cubits/farms/farms_state.dart';
import 'package:finca/models/farms_screen/farm_model.dart';
import 'package:finca/modules/farms_screen/models/crop/Crop.dart';
import 'package:finca/modules/farms_screen/models/tag.dart';
import 'package:finca/services/storage_service.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:finca/utils/collection_refs.dart';
import 'package:finca/utils/user_preferences.dart';
import 'package:finca/views/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StepFourNewFarmScreen extends StatefulWidget {
  const StepFourNewFarmScreen({
    super.key,
    required this.selectedCrops,
    required this.name,
    required this.size,
    required this.selectedSoilType,
    this.description,
    required this.selectedPolygons,
    required this.polygonImage,
  });

  final List<Crop> selectedCrops;
  final String name;
  final String size;
  final Tag selectedSoilType;
  final String? description;
  final Set<Polygon> selectedPolygons;
  final Uint8List polygonImage;

  @override
  _StepFourNewFarmScreenState createState() => _StepFourNewFarmScreenState();
}

class _StepFourNewFarmScreenState extends State<StepFourNewFarmScreen> {
  final _soilStudyController = TextEditingController();
  final _certificationController = TextEditingController();

  // Mock data for dropdowns
  final List<String> soilStudies = ['Soil Study 1', 'Soil Study 2', 'Soil Study 3'];
  final List<String> certifications = ['Certification 1', 'Certification 2', 'Certification 3'];

  String? selectedSoilStudy;

  String? selectedCertification;
  DateTime? selectedSoilDate = DateTime.now(), selectedCertificationDate = DateTime.now();
  List<File> attachedFiles = [];
  bool isLoading = false;

  @override
  initState() {
    selectedSoilStudy = soilStudies[0];
    selectedCertification = certifications[0];
    super.initState();
  }

  Future<void> _pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // PlatformFile file = result.files.first;
      File file = File(result.files.first.path!);
      setState(() {
        attachedFiles.add(file);
      });
    }
  }

  @override
  void dispose() {
    _soilStudyController.dispose();
    _certificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FarmCubit(),
      child: BlocConsumer<FarmCubit, FarmsState>(
        listener: (context, state) {
          log('stepThreeNewFarmScreen: $state');
          if (state is AddFarmsLoadingState) {
            isLoading = true;
          } else if (state is AddFarmsSuccessState) {
            isLoading = false;
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else if (state is AddFarmsFailedState) {
            isLoading = false;
            _showErrorDialog();
          }
        },
        builder: (BuildContext context, FarmsState state) {
          log('buildState: $state');
          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 16.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
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
                                  AppStrings.newFarm,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.greenColor,
                                    fontFamily: Assets.rubik,
                                  ),
                                ),
                                Text(
                                  AppStrings.stepFour,
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
                        Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildDropdown(
                                'Soil study:',
                                soilStudies,
                                selectedSoilStudy,
                                (value) {
                                  setState(() {
                                    selectedSoilStudy = value;
                                  });
                                },
                              ),
                              _buildDatePicker('Date:', selectedSoilDate, (value) {
                                setState(() {
                                  selectedSoilDate = value;
                                });
                              }),
                              const SizedBox(height: 20),
                              _buildFileAttachmentSection(),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildDropdown(
                                'Agricultural Certifications obtained:',
                                certifications,
                                selectedCertification,
                                (value) {
                                  setState(() {
                                    selectedCertification = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildDatePicker('Date:', selectedCertificationDate, (value) {
                                setState(() {
                                  selectedCertificationDate = value;
                                });
                              }),
                              const SizedBox(height: 20),
                              CupertinoButton(
                                color: AppColors.greenColor,
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (checkIfFieldsAreEmpty()) {
                                          _showErrorDialog();
                                        } else {
                                          String farmId = CollectionRefs.instance
                                              .crops(UserPreferences().getUserInfo()?.uid ?? '')
                                              .id;
                                          if (context.mounted) {
                                            context.read<FarmCubit>().addNewFarm(
                                                  farmId,
                                                  widget.name,
                                                  double.parse(widget.size),
                                                  widget.description ?? '',
                                                  widget.selectedPolygons,
                                                  widget.selectedCrops,
                                                  selectedSoilStudy ?? '',
                                                  selectedSoilDate ?? DateTime.now(),
                                                  attachedFiles,
                                                  selectedCertification ?? '',
                                                  selectedCertificationDate ?? DateTime.now(),
                                                );
                                          }
                                        }
                                      },
                                child: Center(
                                  child: isLoading
                                      ? const CupertinoActivityIndicator()
                                      : const Text(
                                          'Finish',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedItem, Function(String? value) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD9D9D9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            items: items
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
            value: selectedItem,
            onChanged: (String? value) {
              onChanged(value);
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDatePicker(String title, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return CustomTextField(
      name: title,
      hintText: "Select date",
      borderColor: const Color(0xFFD9D9D9),
      icon: Assets.calendarIcon,
      iconOnLeft: false,
      isCalendarPicker: true,
      onDateSelected: (selectedDate) {
        onDateSelected(selectedDate);
      },
    );
  }

  Widget _buildFileAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add soil study:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(20),
            color: AppColors.lightGrey,
          ),
          padding: const EdgeInsets.all(20),
          child: attachedFiles.isNotEmpty
              ? Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: attachedFiles.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      attachedFiles[index].path.split('/').last,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.darkGrey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        attachedFiles.removeAt(index);
                                      });
                                    },
                                    child: SvgPicture.asset(Assets.delete),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.createBtn,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Attach Pdf',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        _pickPDFFile();
                      },
                    ),
                  ],
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.createBtn,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Attach PDF',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _pickPDFFile();
                  },
                ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  bool checkIfFieldsAreEmpty() {
    return selectedSoilStudy == null ||
        selectedSoilDate == null ||
        selectedCertification == null ||
        selectedCertificationDate == null ||
        attachedFiles.isEmpty;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill all the fields'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
