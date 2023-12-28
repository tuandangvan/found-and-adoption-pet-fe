import 'package:flutter/material.dart';

class PaginatedList extends StatefulWidget {
  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  // Danh sách tất cả các mục
  List<String> allItems = List.generate(100, (index) => 'Item $index');

  // Số lượng mục hiển thị mỗi lần phân trang
  int itemsPerPage = 10;

  // Vị trí hiện tại của danh sách
  int currentPage = 0;

  // Danh sách các mục hiển thị trên màn hình
  List<String> visibleItems = [];

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
  }

  // Logic để tải thêm mục khi người dùng kéo xuống cuối danh sách
  Future<void> _loadMoreItems() async {
    int start = currentPage * itemsPerPage;
    int end = (currentPage + 1) * itemsPerPage;

    if (end <= allItems.length) {
      // Nếu còn nhiều mục để hiển thị, thêm chúng vào danh sách hiển thị
      setState(() {
        visibleItems.addAll(allItems.getRange(start, end));
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paginated List'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent) {
            // Khi người dùng kéo xuống cuối danh sách, thực hiện phân trang
            _loadMoreItems();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            // Hiển thị các mục từ danh sách hiển thị
            return ListTile(
              title: Text(visibleItems[index]),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaginatedList(),
  ));
}
