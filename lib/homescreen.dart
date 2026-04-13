import 'package:flutter/material.dart';
import 'package:ricecare/constants/colors.dart';
import 'package:ricecare/profileuiscreen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<String>> notes = {
    DateTime.utc(2026, 4, 12): ["Water the rice field", "Check leaf disease"],
    DateTime.utc(2026, 4, 15): ["Apply fertilizer"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Rice",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Care",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Good morning 🌱",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfileScreenUI()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage("assets/images/paddy1.jpg"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 🔹 Scan Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F6EA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.document_scanner, color: AppColors.btnbgrColor),
                    const SizedBox(width: 12),
                    Text(
                      "Scan and identify rice diseases",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.btnbgrColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 🔹 Weather
              sectionTitle("Today's Weather"),
              const SizedBox(height: 12),
              weatherCard(),

              const SizedBox(height: 22),

              // 🔹 Quick Actions
              sectionTitle("Quick Actions"),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  actionCard("Ask AI", Icons.smart_toy, Colors.blue),
                  actionCard("History", Icons.history, Colors.orange),
                  actionCard("Guide", Icons.menu_book, Colors.purple),
                  actionCard("Community", Icons.people, Colors.green),
                ],
              ),

              const SizedBox(height: 22),

              // 🔹 Planner
              sectionTitle("My Planner"),
              const SizedBox(height: 12),

              calendarPlanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarPlanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: today,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),

            eventLoader: (day) {
              return notes[DateTime.utc(day.year, day.month, day.day)] ?? [];
            },

            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                today = focused;
              });
            },

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),

            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),

          const SizedBox(height: 14),

          ...getNotesForDay(selectedDay).map((note) => noteItem(note)),
        ],
      ),
    );
  }

  List<String> getNotesForDay(DateTime day) {
    return notes[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  Widget noteItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_note, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Section Title
  Widget sectionTitle(
    String title, {
    bool showAction = false,
    String actionText = "View all",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (showAction)
          Text(
            actionText,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  // 🔹 Weather Card
  Widget weatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4FC3F7), Color(0xff1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Da Nang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Sunny day",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
              Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 34),
            ],
          ),

          const SizedBox(height: 10),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "31",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("°C", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              weatherInfo(Icons.water_drop, "Humidity", "78%"),
              weatherInfo(Icons.air, "Wind", "12 km/h"),
              weatherInfo(Icons.thermostat, "Feels", "34°C"),
            ],
          ),
        ],
      ),
    );
  }

  Widget weatherInfo(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // 🔹 Quick Action Card
  Widget actionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Planner Card
  Widget plannerCard(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_outline, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
