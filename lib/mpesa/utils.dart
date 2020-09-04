
timestampconvertion() async {

  try {
    final DateTime now = DateTime.now();


    var formatted = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";

    return formatted;
  } catch (e) {
    print(e);
  }
}
