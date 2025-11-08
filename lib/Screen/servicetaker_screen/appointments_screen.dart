import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/myService_model.dart';
import 'package:SerialMan/providers/serviceTaker_provider/mySerials/mySerial_provider.dart';
import 'package:SerialMan/utils/color.dart';
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import 'package:SerialMan/global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import 'package:SerialMan/global_widgets/custom_textfield.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool _isFilterVisible = false;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MySerialServiceTakerProvider>(
        context,
        listen: false,
      );
      if (provider.myServices.isEmpty) {
        provider.fetchMyServices(isRefresh: true);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<MySerialServiceTakerProvider>(
      context,
      listen: false,
    );
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        _selectedDate == null) {
      if (provider.hasMore && !provider.isLoading) {
        provider.fetchMyServices();
      }
    }
  }

  // handleRefresh function
  Future<void> _handleRefresh() async {
    _clearFilter();
    await context.read<MySerialServiceTakerProvider>().fetchMyServices(
      isRefresh: true,
    );
  }

  // selectDate function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: false,
            colorScheme: ColorScheme.light(
              primary: AppColor().primariColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor().primariColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDate = null;
      _dateController.clear();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String todayHint = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      body: Consumer<MySerialServiceTakerProvider>(
        builder: (context, mySerialProvider, child) {
          final List<MyService> filteredServices = _selectedDate == null
              ? mySerialProvider.myServices
              : mySerialProvider.myServices.where((service) {
                  if (service.statusTime == null) return false;
                  return DateUtils.isSameDay(
                    service.statusTime!,
                    _selectedDate,
                  );
                }).toList();
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            backgroundColor: Colors.white,
            color: AppColor().primariColor,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  ClipPath(
                    clipper: ClipPathClipper(),
                    child: Container(
                      color: AppColor().primariColor,
                      height: 150,
                      width: double.maxFinite,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _buildHeader(todayHint),
                        const SizedBox(height: 20),
                        if (mySerialProvider.isLoading &&
                            mySerialProvider.myServices.isEmpty)
                          CustomShimmerList(itemCount: 10)
                        else if (filteredServices.isEmpty)
                          _buildEmptyMessage()
                        else
                          _buildServiceList(filteredServices, mySerialProvider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // buildHeader function
  Widget _buildHeader(String todayHint) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Serial History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isFilterVisible = !_isFilterVisible;
                });
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isFilterVisible ? 60 : 0,
          child: _isFilterVisible
              ? Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            readOnly: true,
                            filled: true,
                            fillColor: Colors.white,
                            controller: _dateController,
                            hintText: todayHint,
                            textStyle: const TextStyle(color: Colors.black),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                right: 8.0,
                              ),
                              child: Text(
                                "Service Date :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // এবং এই লাইনটি যোগ করুন
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: AppColor().primariColor,
                            ),
                            isPassword: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // buildServiceList function
  Widget _buildServiceList(
    List<MyService> services,
    MySerialServiceTakerProvider provider,
  ) {
    return Column(
      children: [
        ...services.map((service) => _buildSerialListItem(service)).toList(),
        if (provider.hasMore && _selectedDate == null && !provider.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CustomLoading()),
          )
        else if (services.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _buildTheEndDivider(),
          ),
      ],
    );
  }

  // buildEmptyMessage function
  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No serial found.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildTheEndDivider(),
          ],
        ),
      ),
    );
  }

  // buildSerialListItem function
  Widget _buildSerialListItem(MyService service) {
    final serviceDate = service.statusTime != null
        ? DateFormat('dd/MM/yyyy').format(service.statusTime!)
        : 'N/A';
    final bookingTime = service.createdTime != null
        ? DateFormat('hh:mm:ss a').format(service.createdTime!)
        : 'N/A';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: AppColor().primariColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.company?.name ?? 'No Organization',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.serviceCenter?.name ?? 'No Organization',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor().primariColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (service.serviceType?.name != null)
                    Text(
                      service.serviceType!.name ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Serial No.: ${service.serialNo}',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                  Text(
                    '${service.status ?? 'N/A'} at: $bookingTime',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // buildTheEndDivider function
  Widget _buildTheEndDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("The end", style: TextStyle(color: Colors.grey[600])),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
