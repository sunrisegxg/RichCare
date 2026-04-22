import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ricecare/constants/colors.dart';
import 'package:ricecare/profileuiscreen.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/plannernote.dart';
import 'services/planner_service.dart';
import 'services/token_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  final noteService = PlannerService();
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  StreamSubscription? _noteSub;

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<PlannerNote>> notes = {};
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  DateTime normalize(DateTime day) {
    return DateTime.utc(day.year, day.month, day.day);
  }

  void loadUser() async {
    final id = await TokenService.getUserId();

    userId = id;
    if (!mounted || userId == null) return;

    await _noteSub?.cancel();

    _noteSub = noteService.getNotes(userId!).listen((list) {
      if (!mounted) return;

      final Map<DateTime, List<PlannerNote>> loaded = {};

      for (final note in list) {
        final key = normalize(note.date);
        loaded.putIfAbsent(key, () => []);
        loaded[key]!.add(note);
      }

      setState(() {
        notes = loaded;
      });
    });
  }

  @override
  void dispose() {
    _noteSub?.cancel();
    super.dispose();
  }

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
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFE7F6EA),
              //     borderRadius: BorderRadius.circular(18),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.document_scanner, color: AppColors.btnbgrColor),
              //       const SizedBox(width: 12),
              //       Text(
              //         "Scan and identify rice diseases",
              //         style: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           fontSize: 14,
              //           color: AppColors.btnbgrColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
            calendarFormat: _calendarFormat,
            pageAnimationEnabled: true,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),

            eventLoader: (day) {
              return notes[normalize(day)] ?? [];
            },

            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = selected; // quan trọng: dùng selected
              });
            },
            onDayLongPressed: (selected, focused) async {
              setState(() {
                selectedDay = selected;
                focusedDay = selected; // nhảy đúng tháng của ngày bấm
              });

              await showAddNoteSheet(selected);
            },

            onPageChanged: (newFocusedDay) {
              focusedDay = newFocusedDay;
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

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final dayNotes = notes[normalize(day)] ?? [];

                final hasReminder = dayNotes.any(
                  (item) => item.reminder != null,
                );

                if (hasReminder) {
                  return const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.star, size: 12, color: Colors.amber),
                  );
                }

                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: 14),

          ...getNotesForDay(selectedDay).map((note) => noteItem(note)),
        ],
      ),
    );
  }

  List<PlannerNote> getNotesForDay(DateTime day) {
    return notes[normalize(day)] ?? [];
  }

  Widget noteItem(PlannerNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            note.reminder != null ? Icons.star : Icons.event_note,
            color: note.reminder != null ? Colors.amber : Colors.green,
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                if (note.description != null &&
                    note.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    note.description!,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],

                if (note.reminder != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.alarm, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        note.reminder!.format(context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAddNoteSheet(DateTime day) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TimeOfDay? reminder;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                18,
                14,
                18,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Handle
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "Add Planner Note",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// Date Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F7F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${day.day}/${day.month}/${day.year}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Title
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title *",
                      prefixIcon: const Icon(Icons.title),
                      filled: true,
                      fillColor: const Color(0xffF8FAF8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Description
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description (optional)",
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 52),
                        child: Icon(Icons.notes),
                      ),
                      filled: true,
                      fillColor: const Color(0xffF8FAF8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Reminder
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (picked != null) {
                        setSheetState(() {
                          reminder = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8FAF8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm, color: Colors.orange),
                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              reminder == null
                                  ? "Set reminder"
                                  : reminder!.format(context),
                              style: TextStyle(
                                color: reminder == null
                                    ? Colors.black54
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          if (reminder != null)
                            InkWell(
                              onTap: () {
                                setSheetState(() {
                                  reminder = null;
                                });
                              },
                              child: const Icon(Icons.close, size: 18),
                            )
                          else
                            const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.btnbgrColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        if (titleController.text.trim().isEmpty) return;

                        final key = normalize(day);

                        final newNote = PlannerNote(
                          id: "",
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          date: day,
                          reminder: reminder,
                        );

                        if (userId == null) return;

                        await noteService.addNote(userId!, newNote);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save Note",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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

  Widget weatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🔹 TOP 50 / 50
          Row(
            children: [
              /// LEFT ICON
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Image.asset("assets/images/cloudy.png", height: 90),
                  ),
                ),
              ),

              /// Divider giữa
              Container(
                width: 1,
                height: 95,
                color: Colors.white.withOpacity(0.25),
              ),

              /// RIGHT INFO
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Da Nang",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "27°",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Sunny cloudy",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Monday, 18 Apr",
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Divider ngang
          Container(height: 1, color: Colors.white.withOpacity(0.25)),

          const SizedBox(height: 14),

          /// 🔹 Bottom Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              weatherInfoBlue("assets/images/wind.png", "Wind", "7 km/h"),
              weatherInfoBlue("assets/images/humidity.png", "Humidity", "82%"),
              weatherInfoBlue("assets/images/protection.png", "Rain", "20%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget weatherInfoBlue(String image, String title, String value) {
    return Column(
      children: [
        Image.asset(image, height: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
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
