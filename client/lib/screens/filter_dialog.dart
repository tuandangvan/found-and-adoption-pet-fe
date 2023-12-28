import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bộ Lọc Thú Cưng'),
      ),
      body: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedBreed;
  RangeValues selectedAgeRange = RangeValues(1, 10);
  List<String> selectedColors = [];
  List<String> allColors = [
    'Đen',
    'Trắng',
    'Đỏ',
    'Vàng',
    'Hồng',
    'Nâu',
    'Xám',
    'Khác'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select breed:'),
            DropdownButton<String>(
              value: selectedBreed,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBreed = newValue;
                  });
                }
              },
              items: <String>[
                'Husky',
                'Poodle',
                'Pitpull',
                'Chó cỏ',
                'Mèo ta',
                'Mèo Anh lông ngắn',
                'Khác'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
                'Select old: ${selectedAgeRange.start.toInt()} - ${selectedAgeRange.end.toInt()} năm'),
            RangeSlider(
              values: selectedAgeRange,
              min: 0,
              max: 10,
              onChanged: (RangeValues values) {
                setState(() {
                  selectedAgeRange = values;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Select color:'),
            Column(
              children: allColors.map((String color) {
                return CheckboxListTile(
                  title: Text(color),
                  value: selectedColors.contains(color),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedColors.add(color);
                        } else {
                          selectedColors.remove(color);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try{
                List<int> listAge =
                    convertRangeValuesToListInt(selectedAgeRange);

                List<Pet> dataPet = await filterPet(
                    selectedBreed, selectedColors, listAge);

                    print('hú hú: $dataPet');
                Navigator.pop<List<Pet>>(context, dataPet); 
                
              }catch(e){
                print('errorr12: ${e.toString()}');
              }},
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  List<int> convertRangeValuesToListInt(RangeValues values) {
    int start = values.start.round();
    int end = values.end.round();
    return List<int>.generate(end - start + 1, (i) => i + start);
  }
}
