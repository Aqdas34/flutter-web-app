import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'package:only_shef/pages/chef/appointments/services/chef_services.dart';
import 'package:only_shef/pages/chef_appointments/models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;
  final bool isFromPending;
  final bool isFromAccepted;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
    this.isFromPending = false,
    this.isFromAccepted = false,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  bool _isLoading = false;
  late Appointment _appointment;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Future<void> _updateAppointmentStatus(String status) async {
    setState(() {
      _isLoading = true;
    });

    final ChefAppointmentService appointmentService = ChefAppointmentService();
    final bool success = await appointmentService.updateAppointmentStatus(
      context,
      _appointment.id,
      status,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        _appointment = Appointment(
          id: _appointment.id,
          chefId: _appointment.chefId,
          chefInfo: _appointment.chefInfo,
          userId: _appointment.userId,
          date: _appointment.date,
          time: _appointment.time,
          selectedCuisines: _appointment.selectedCuisines,
          numberOfPersons: _appointment.numberOfPersons,
          price: _appointment.price,
          comments: _appointment.comments,
          status: status,
          createdAt: _appointment.createdAt,
          updatedAt: DateTime.now(),
        );
      }
    });

    if (success) {
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pop(context, true); // Return true to indicate update success
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Appointment Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chef Info Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  _appointment.chefInfo.profileImage),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _appointment.chefInfo.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _appointment.chefInfo.specialties.isNotEmpty
                            ? Text(
                                _appointment.chefInfo.specialties.first,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              )
                            : Text(
                                "There are no cuisines",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Appointment Details Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Details',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDetailRow(
                            'Date',
                            DateFormat('dd MMM, yyyy')
                                .format(_appointment.date)),
                        _buildDetailRow('Time', _appointment.time),
                        _buildDetailRow('Status', _appointment.status),
                        _buildDetailRow('Number of Persons',
                            _appointment.numberOfPersons.toString()),
                        _buildDetailRow('Price', 'Rs. ${_appointment.price}'),
                        _buildDetailRow(
                          'Cuisine',
                          _appointment.selectedCuisines.isNotEmpty
                              ? _appointment.selectedCuisines.first
                              : '-',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Comments Section
                  if (_appointment.comments.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Special Instructions',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _appointment.comments,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.isFromPending || widget.isFromAccepted)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.isFromPending) {
                                  _updateAppointmentStatus('Rejected');
                                } else if (widget.isFromAccepted) {
                                  _updateAppointmentStatus('Cancelled');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                widget.isFromPending ? "Reject" : "Cancel",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 50,
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.isFromPending) {
                                  _updateAppointmentStatus('Accepted');
                                } else if (widget.isFromAccepted) {
                                  _updateAppointmentStatus('Completed');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: Text(
                                widget.isFromPending ? "Accept" : "Complete",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
