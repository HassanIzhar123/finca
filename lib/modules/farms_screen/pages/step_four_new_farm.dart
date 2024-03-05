import 'package:finca/modules/farms_screen/pages/step_one_new_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepFourNewFarmScreen extends StatefulWidget {
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
  DateTime? selectedDate;

  @override
  void dispose() {
    _soilStudyController.dispose();
    _certificationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Farm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Step 4 of 4', style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 20),
              _buildDropdown('Soil study:', soilStudies, selectedSoilStudy),
              _buildDatePicker('Date:', selectedDate),
              _buildFileAttachmentSection(),
              _buildDropdown('Agricultural Certifications obtained:', certifications, selectedCertification),
              _buildDatePicker('Date:', selectedDate),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Finish'),
                  onPressed: () {
                    // Form submission logic
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => StepOneNewActivity()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedItem,
          hint: Text('Select option'),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDatePicker(String title, DateTime? selectedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 10),
        TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            controller: TextEditingController(text: selectedDate != null ? DateFormat.yMd().format(selectedDate) : ''),
            decoration: InputDecoration(
              labelText: "Enter Email",
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.calendar_today),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
            )),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFileAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add soil study:'),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey),
            SizedBox(width: 10),
            Text('Filename.pdf'),
            Spacer(),
            IconButton(icon: Icon(Icons.close), onPressed: () {}),
          ],
        ),
        Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey),
            SizedBox(width: 10),
            Text('Filename.pdf'),
            Spacer(),
            IconButton(icon: Icon(Icons.close), onPressed: () {}),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text('Add PDF'),
          onPressed: () {
            // File picker logic
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
