String formatWilayah(String str) {
  final List<String> arrText = str.split('of ');
  String arrTextOne = arrText[0]
      .replaceAll(' ENE ', ' TimurTimurLaut')
      .replaceAll(' NNE ', ' UtaraTimurLaut')
      .replaceAll(' NE ', ' TimurLaut')
      .replaceAll(' N ', ' Utara')
      .replaceAll(' SSE ', ' SelatanTenggara')
      .replaceAll(' ESE ', ' TimurTenggara')
      .replaceAll(' SE ', ' Tenggara')
      .replaceAll(' E ', ' Timur')
      .replaceAll(' WSW ', ' BaratBaratDaya')
      .replaceAll(' SSW ', ' SelatanBaratDaya')
      .replaceAll(' SW ', ' BaratDaya')
      .replaceAll(' S ', ' Selatan')
      .replaceAll(' NNW ', ' UtaraBaratLaut')
      .replaceAll(' WNW ', ' BaratBaratLaut')
      .replaceAll(' NW ', ' BaratLaut')
      .replaceAll(' W ', ' Barat');
  String arrTextTwo = '';
  if (arrText.length > 1) {
    arrTextTwo = " ${arrText[1].replaceAll(', ', '-').toUpperCase()}";
  }
  return "$arrTextOne$arrTextTwo";
}
