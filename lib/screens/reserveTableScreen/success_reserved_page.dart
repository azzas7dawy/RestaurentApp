import 'package:flutter/material.dart';

void showReservationSuccess(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ReservationSuccessSheet(),
  );
}

class ReservationSuccessSheet extends StatelessWidget {
  const ReservationSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Success",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your table is reserved",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "NOTE: Reservation is only for 1 hour",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          // ✅ Success Circle with Icon
          Stack(
            alignment: Alignment.center,
            children: [
              // Fake sparkles (can be animated later)
              Positioned(
                top: 0,
                child: Icon(Icons.star, color: Colors.orange, size: 16),
              ),
              Positioned(
                left: 0,
                child: Icon(Icons.circle, color: Colors.greenAccent, size: 10),
              ),
              Positioned(
                right: 0,
                child: Icon(Icons.circle, color: Colors.greenAccent, size: 12),
              ),
              Positioned(
                bottom: 0,
                child: Icon(Icons.star, color: Colors.orange, size: 16),
              ),

              // ✅ Main Circle with check
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 50, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}