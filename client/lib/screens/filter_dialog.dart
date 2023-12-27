import 'package:flutter/material.dart';



class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bộ Lọc Thú Cưng'),
        ),
        body: FilterScreen(),
      ),
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
  List<String> allColors = ['Đen', 'Trắng', 'Đỏ', 'Vàng', 'Hồng', 'Nâu', 'Xám', 'Khác'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn Giống:'),
            DropdownButton<String>(
              value: selectedBreed,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBreed = newValue;
                  });
                }
              },
              items: <String>['Husky', 'Poodle', 'Pitpull', 'Chó cỏ', 'Mèo ta', 'Mèo Anh lông ngắn', 'Khác']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Chọn Tuổi: ${selectedAgeRange.start.toInt()} - ${selectedAgeRange.end.toInt()} năm'),
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
            Text('Chọn Màu Sắc:'),
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
              onPressed: () {
                print('Giống đã chọn: $selectedBreed');
                print('Tuổi đã chọn: ${selectedAgeRange.start} - ${selectedAgeRange.end}');
                print('Màu đã chọn: $selectedColors');
              },
              child: Text('Áp Dụng Bộ Lọc'),
            ),
          ],
        ),
      ),
    );
  }
}
