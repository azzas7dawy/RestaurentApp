import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:restrant_app/widgets/app_snackbar.dart';

class YourReservationScreen extends StatefulWidget {
  const YourReservationScreen({super.key});
  static const String id = 'MyReservationScreen';

  @override
  State<YourReservationScreen> createState() => _YourReservationScreenState();
}

class _YourReservationScreenState extends State<YourReservationScreen> {
  // GlobalKey للوصول إلى ScaffoldMessenger بشكل آمن
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).yourReservation,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getUserReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 50,
                  color: ColorsUtility.errorSnackbarColor,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).somethingWrong,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorsUtility.errorSnackbarColor,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final reservations = snapshot.data ?? [];
        if (reservations.isEmpty) {
          return _buildEmptyReservations();
        }

        return _buildReservationsList(reservations);
      },
    );
  }

  Widget _buildEmptyReservations() {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 60,
                  color: ColorsUtility.errorSnackbarColor.withAlpha(128),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).noReservation,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).yourReservationsWillAppearHere,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsUtility.textFieldLabelColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsList(List<Map<String, dynamic>> reservations) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          final String status = reservation['status'];
          final Color statusColor = _getStatusColor(status);
          final String localizedStatus = _getLocalizedStatus(status, context);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildReservationCard(
                    reservation, statusColor, localizedStatus),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation,
      Color statusColor, String localizedStatus) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Card(
      color: isDarkTheme
          ? ColorsUtility.elevatedBtnColor
          : ColorsUtility.lightMainBackgroundColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${S.of(context).tableNumber} ${reservation['id']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    localizedStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reservation['date'],
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsUtility.lightOnboardingDescriptionColor,
                  ),
                ),
                if (reservation['status'] == 'pending') ...[
                  IconButton(
                    onPressed: () => _confirmDeleteReservation(reservation),
                    icon: const Icon(
                      Icons.delete,
                      color: ColorsUtility.errorSnackbarColor,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${S.of(context).reservationName}: ${reservation['name']}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkTheme
                    ? ColorsUtility.textFieldLabelColor
                    : ColorsUtility.lightTextFieldLabelColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${reservation['timeArriving']} - ${reservation['timeLeaving']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorsUtility.progressIndictorColor.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorsUtility.progressIndictorColor,
                ),
              ),
              child: Text(
                '${reservation['numPersons']} ${S.of(context).person}',
                style: TextStyle(
                  color: ColorsUtility.progressIndictorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteReservation(
      Map<String, dynamic> reservation) async {
    final bool? confirmCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDarkTheme = theme.brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkTheme
              ? ColorsUtility.elevatedBtnColor
              : ColorsUtility.lightMainBackgroundColor,
          title: Text(
            S.of(context).cancelReservation,
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
          ),
          content: Text(
            S.of(context).confirmCancelReservationQuestion,
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                S.of(context).confirm,
                style: TextStyle(color: ColorsUtility.errorSnackbarColor),
              ),
            ),
          ],
        );
      },
    );

    if (confirmCancel == true) {
      try {
        await _deleteReservation(reservation['docId']);
        _showSnackbar(S.of(context).reservationCancelled,
            ColorsUtility.successSnackbarColor);
      } catch (e) {
        _showSnackbar('${S.of(context).cancelFailed}: $e',
            ColorsUtility.errorSnackbarColor);
      }
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: ColorsUtility.onboardingColor,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getUserReservations() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: false)
        .snapshots()
        .handleError((error) {
      print('Error fetching reservations: $error');
      return Stream.value([]);
    }).map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': data['tableId'] ?? 0,
            'reservationId': data['reservationId'] ?? '',
            'name': data['name'] ?? '',
            'date': data['date'] ?? '',
            'numPersons': data['numPersons'] ?? 0,
            'timeArriving': data['timeArriving'] ?? '',
            'timeLeaving': data['timeLeaving'] ?? '',
            'status': data['status'] ?? 'pending',
            'docId': doc.id,
            'phone': data['phone'] ?? '',
          };
        }).toList();
      } catch (e) {
        print('Error parsing reservation data: $e');
        return [];
      }
    });
  }

  Future<void> _deleteReservation(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error deleting reservation: $e');
      rethrow;
    }
  }

  String _getLocalizedStatus(String status, BuildContext context) {
    switch (status) {
      case 'accepted':
        return S.of(context).accepted;
      case 'rejected':
        return S.of(context).rejected;
      case 'pending':
      default:
        return S.of(context).pending;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return ColorsUtility.successSnackbarColor;
      case 'rejected':
        return ColorsUtility.errorSnackbarColor;
      case 'pending':
      default:
        return ColorsUtility.progressIndictorColor;
    }
  }
}
