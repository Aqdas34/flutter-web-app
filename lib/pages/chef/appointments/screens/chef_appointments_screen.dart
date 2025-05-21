import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_shef/pages/chef/appointments/services/chef_services.dart';
import 'package:only_shef/pages/chef_appointments/models/appointment.dart';
import 'package:only_shef/pages/chef_appointments/screens/appointment_details_screen.dart';
import 'package:only_shef/pages/chef_appointments/widgets/apointments.dart';
import 'package:only_shef/widgets/chef_nav_bar.dart';

class ChefAppointmentsScreen extends StatefulWidget {
  const ChefAppointmentsScreen({super.key});

  @override
  State<ChefAppointmentsScreen> createState() => _ChefAppointmentsScreenState();
}

class _ChefAppointmentsScreenState extends State<ChefAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1; // Appointments index
  late TabController _tabController;
  bool _isLoading = true;
  AppointmentResponse? _appointmentResponse;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final ChefAppointmentService appointmentService =
          ChefAppointmentService();
      final appointmentResponse =
          await appointmentService.getChefAppointments(context);

      setState(() {
        _appointmentResponse = appointmentResponse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDF7F2),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E451B),
        title: Text(
          'Appointments',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E451B)))
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.red.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error Loading Appointments',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _errorMessage,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Color(0xFF707070),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadAppointments,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1E451B),
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _appointmentResponse != null
                      ? TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAppointmentList(
                                _appointmentResponse!.grouped['pending'] ?? []),
                            _buildAppointmentList(
                                _appointmentResponse!.grouped['accepted'] ??
                                    []),
                            _buildAppointmentList(
                                _appointmentResponse!.grouped['completed'] ??
                                    []),
                            _buildAppointmentList(
                                _appointmentResponse!.grouped['cancelled'] ??
                                    []),
                            _buildAppointmentList(
                                _appointmentResponse!.grouped['rejected'] ??
                                    []),
                          ],
                        )
                      : _buildEmptyState(),
          Positioned(
            bottom: 10,
            left: 50,
            right: 50,
            child: ChefNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/chef-home');
                    break;
                  case 1:
                    // Already on appointments screen
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(context, '/chef-messages');
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(
                        context, '/profile-settings');
                    break;
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _errorMessage.isEmpty && !_isLoading
          ? FloatingActionButton(
              onPressed: _loadAppointments,
              backgroundColor: Color(0xFF1E451B),
              child: Icon(Icons.refresh, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      color: Color(0xFF1E451B),
      child: ListView.builder(
        padding: EdgeInsets.only(
            bottom:
                100), // Add padding to avoid overlapping with navigation bar
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              // Navigate to appointment details and wait for result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailsScreen(
                    appointment: appointments[index],
                    isFromPending:
                        appointments[index].status.toLowerCase() == 'pending',
                    isFromAccepted:
                        appointments[index].status.toLowerCase() == 'accepted',
                  ),
                ),
              );

              // If status was updated, refresh the list
              if (result == true) {
                _loadAppointments();
              }
            },
            child: SizedBox(
              height: 280,
              child: AppointmentWidget(
                appointment: appointments[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 80,
            color: Color(0xFF1E451B).withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No Appointments Yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your appointments will appear here',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Color(0xFF707070),
            ),
          ),
        ],
      ),
    );
  }
}
