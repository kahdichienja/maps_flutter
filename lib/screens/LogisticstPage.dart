import 'package:flutter/material.dart';
import '../Models/Logistics.dart';

class DashboardTable extends StatefulWidget {
  const DashboardTable({Key key}) : super(key: key);

  @override
  _DashboardTableState createState() => _DashboardTableState();
}

class _DashboardTableState extends State<DashboardTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: Text(
          'Select Your Delivery.',
          style: TextStyle(fontSize: 15.0),
        ),
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: <int>[5, 10, 20, 15],
        onRowsPerPageChanged: (int value) {
          setState(() {
            _rowsPerPage = value;
          });
        },
        columns: TableColumns,
        source: LogisticsDataSource(),
      ),
    );
  }
}

////// Columns in table.
const TableColumns = <DataColumn>[
  DataColumn(
    label: const Text('#'),
  ),
  DataColumn(
    label: const Text('Delivery Name.'),
    tooltip: 'Name',
    numeric: true,
  ),
  DataColumn(
    label: const Text('Duration Per Km'),
    numeric: true,
  ),
  DataColumn(
    label: const Text('Price Per Km'),
    numeric: true,
  ),
  DataColumn(
    label: const Text('Outside Kenya Price'),
    numeric: true,
  ),
  DataColumn(
    label: const Text(
      'Outside City',
      style: TextStyle(color: Colors.redAccent),
    ),
    numeric: true,
  ),
];


////// Data source class for obtaining row data for PaginatedDataTable.
class LogisticsDataSource extends DataTableSource {
  int _selectedCount = 0;
  final List<Logistics> _logistics = <Logistics>[
    /**TODO: Implement This Through Fake Data */
    new Logistics()
  ];

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _logistics.length) return null;
    final Logistics dataset = _logistics[index];
    return DataRow.byIndex(index: index,
        // selected: dataset.selected,
        // onSelectChanged: (bool value) {
        //   if (dataset.selected != value) {
        //     _selectedCount += value ? 1 : -1;
        //     assert(_selectedCount >= 0);
        //     dataset.selected = value;
        //     notifyListeners();
        //   }
        // },
        cells: <DataCell>[
          DataCell(Text('${dataset.logId}')),
          DataCell(Text('${dataset.logisticName}')),
          DataCell(Text(
            '${dataset.pricePerKm}',
            style: TextStyle(color: Colors.blueAccent),
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
          )),
          DataCell(
            Text('${dataset.exceptionsIn.outsideCountry.pricePerKm}',
                style: TextStyle(
                  color: Colors.greenAccent,
                )),
            onTap: () {},
          ),
          DataCell(Text('${dataset.exceptionsIn.outsideTown.pricePerKm}')),
        ]);
  }

  @override
  int get rowCount => _logistics.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
