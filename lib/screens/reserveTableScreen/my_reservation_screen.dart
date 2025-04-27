import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';

class YourReservationScreen extends StatelessWidget {
  const YourReservationScreen({super.key});
  static const String id = 'MyReservationScreen';

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
            'id': data['id'] ?? 0,
            'name': data['name'] ?? '',
            'date': data['date'] ?? '',
            'numPersons': data['numPersons'] ?? 0,
            'timeArriving': data['timeArriving'] ?? '',
            'timeLeaving': data['timeLeaving'] ?? '',
            'docId': doc.id,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).yourReservation,
          style: textTheme.headlineMedium,
        ),
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getUserReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
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
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).somethingWrong,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final reservations = snapshot.data ?? [];
          if (reservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 50,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).noReservation,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Dismissible(
                key: Key(reservation['docId']),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: colorScheme.error,
                  child: Icon(Icons.delete, color: colorScheme.onError),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(S.of(context).deleteReservation),
                      content: Text(S.of(context).confirmDeleteReservation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(S.of(context).cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            S.of(context).delete,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  try {
                    await _deleteReservation(reservation['docId']);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(S.of(context).reservationDeleted),
                    //     backgroundColor: colorScheme.primary,
                    //   ),
                    // );
                  } catch (e) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('${S.of(context).deleteFailed}: $e'),
                    //     backgroundColor: colorScheme.error,
                    //   ),
                    // );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: colorScheme.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              backgroundColor:
                                  colorScheme.primary.withOpacity(0.2),
                              label: Text(
                                '${reservation['numPersons']} ${S.of(context).person}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${S.of(context).reservationName}: ${reservation['name']}',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${S.of(context).date}: ${reservation['date']}',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${reservation['timeArriving']} - ${reservation['timeLeaving']}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
