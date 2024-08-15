import 'package:flutter/material.dart';
import './text.dart';

TableRow tr(String col1, String col2) {
  return TableRow(
    children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: text(
            col1,
            color: Colors.black45,
            weight: FontWeight.bold,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: text(col2),
        ),
      ),
    ],
  );
}
