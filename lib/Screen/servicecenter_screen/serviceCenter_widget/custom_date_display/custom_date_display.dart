import 'package:SerialMan/providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import 'package:SerialMan/utils/color.dart';

class CustomDateDisplay extends StatefulWidget {
  final DateTime selectedDate;

  const CustomDateDisplay({Key? key, required this.selectedDate})
    : super(key: key);

  @override
  _CustomDateDisplayState createState() => _CustomDateDisplayState();
}

class _CustomDateDisplayState extends State<CustomDateDisplay> {
  final DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final serialProvider = context.watch<GetNewSerialButtonProvider>();
    final ServingStatus = serialProvider.currentlyServingSerial?.status;
    final bool Status = ServingStatus == "Serving";
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(widget.selectedDate);
    final bool isToday = todayString == selectedDateString;

    String displayDayText;
    if (isToday) {
      displayDayText = "Today";
    } else {
      displayDayText = DateFormat('EEEE').format(widget.selectedDate);
    }

    return Consumer<GetBookSerialProvider>(
      builder: (context, bookSerialProvider, child) {
        final allSerials = [
          ...serialProvider.queueSerials,
          ...serialProvider.servedSerials,
        ];

        final servingSerials = allSerials
            .where((booking) => booking.status?.toLowerCase() == "serving")
            .toList();
        final servingSerialNumbers = servingSerials
            .map((booking) => booking.serialNo)
            .toList();
        final String disPlayText = servingSerialNumbers.join(', ');
        final bool shouldShowCircle = servingSerials.isNotEmpty && isToday;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(_today),
                    style: TextStyle(
                      color: AppColor().primariColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (shouldShowCircle) ...[
              Positioned(
                right: -8,
                top: -20,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColor().primariColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          disPlayText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
