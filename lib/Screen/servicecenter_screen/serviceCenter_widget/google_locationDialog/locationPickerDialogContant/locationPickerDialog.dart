import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../global_widgets/custom_sanckbar.dart';
import '../../../../../utils/color.dart';
import '../../google_map_service/google_map_service.dart';
import '../locationDialogContent.dart';

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({super.key});
  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  LatLng? _selectedLocationFromContent;
  LatLng? _selectedLocation;
  LatLng? _locationFromDropdown;
  final GoogleMapsService _mapsService = GoogleMapsService();
  Suggestion? _selectedPlace;
  List<Suggestion> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().primariColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chose Location",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selectedLocation = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  backgroundColor: Colors.white,
                                  appBar: AppBar(
                                    title: Text(
                                      "Choose Location",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppColor().primariColor,
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        DropdownSearch<Suggestion>(
                                          itemAsString: (s) =>
                                              s.locationName ?? s.description,
                                          selectedItem: _selectedPlace,
                                          asyncItems: (String filter) async {
                                            final data = await _mapsService
                                                .fetchSuggestions(filter);
                                            print(
                                              "Dropdown got ${data.length} items",
                                            );
                                            return data;
                                          },
                                          popupProps: PopupProps.menu(
                                            menuProps: MenuProps(
                                              backgroundColor: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            constraints: BoxConstraints(
                                              maxHeight: 170,
                                            ),
                                          ),
                                          dropdownDecoratorProps: DropDownDecoratorProps(
                                            dropdownSearchDecoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              // suffixIcon: divisionProvider.isLoading
                                              //     ? Container(
                                              //   padding: EdgeInsets.all(12),
                                              //   child: SizedBox(
                                              //     height: 20,
                                              //     width: 20,
                                              //     child: CircularProgressIndicator(
                                              //       strokeWidth: 2.5,
                                              //       color: AppColor().primariColor,
                                              //     ),
                                              //   ),
                                              // )
                                              //     : null,

                                              //  enabled: !divisionProvider.isLoading,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColor().primariColor,
                                                  width: 2,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // selectedItem: _selectDivision,
                                          //items: divisionProvider.divisions,
                                          onChanged: (Suggestion? data) async {
                                            if (data != null) {
                                              final latLng = await _mapsService
                                                  .getLatLngFromPlaceId(
                                                    data.placeId,
                                                  );
                                              setState(() {
                                                _selectedPlace = data;
                                                _locationFromDropdown = latLng;
                                                _selectedLocation = latLng;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null)
                                              return "Please select a division";
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: LocationPickerDialogContent(
                                            newLocationToDisplay:
                                                _locationFromDropdown,
                                            onLocationSelected:
                                                (selectedLatLng) async {
                                                  final placeDetails =
                                                      await _mapsService
                                                          .getPlaceDetailsFromLatLng(
                                                            selectedLatLng,
                                                          );
                                                  setState(() {
                                                    _selectedLocation =
                                                        selectedLatLng;
                                                    _selectedPlace =
                                                        placeDetails;
                                                    _locationFromDropdown =
                                                        null;
                                                  });
                                                },
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColor().primariColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Text(
                                                "Select",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_selectedLocation != null) {
                                                  Navigator.pop(
                                                    context,
                                                    _selectedLocation,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Please select a location from the map or search.",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color:
                                                      AppColor().primariColor,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );

                            if (selectedLocation != null) {
                              Navigator.pop(context, selectedLocation);
                            }
                          },
                          child: Icon(Icons.fullscreen, size: 30),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownSearch<Suggestion>(
                  asyncItems: (String filter) async {
                    final data = await _mapsService.fetchSuggestions(filter);
                    print("Dropdown got ${data.length} items");
                    return data;
                  },
                  itemAsString: (s) => s.locationName ?? s.description,
                  selectedItem: _selectedPlace,
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 170),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: AppColor().primariColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  onChanged: (Suggestion? data) async {
                    if (data != null) {
                      final latLng = await _mapsService.getLatLngFromPlaceId(
                        data.placeId,
                      );
                      setState(() {
                        _selectedPlace = data;
                        _locationFromDropdown = latLng;
                        _selectedLocation = latLng;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) return "Please select a division";
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 500,
                  child: LocationPickerDialogContent(
                    onLocationSelected: (selectedLatLng) async {
                      final placeDetails = await _mapsService
                          .getPlaceDetailsFromLatLng(selectedLatLng);
                      setState(() {
                        _selectedLocation = selectedLatLng;
                        _selectedPlace = placeDetails;
                        _locationFromDropdown = null;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor().primariColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Select",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_selectedLocation != null) {
                          Navigator.pop(context, _selectedLocation);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: CustomSnackBarWidget(
                                title: "Failed",
                                message:
                                    "Please select a location from the map or search.",
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: AppColor().primariColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
