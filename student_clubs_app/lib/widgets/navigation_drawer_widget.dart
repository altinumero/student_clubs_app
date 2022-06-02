import 'package:flutter/material.dart';
import 'package:student_clubs_app/screens/add_club.dart';
import 'package:student_clubs_app/screens/apply_for_club.dart';
import 'package:student_clubs_app/screens/approve.dart';
import 'package:student_clubs_app/screens/check_event_reports.dart';
import 'package:student_clubs_app/screens/check_monthly_reports.dart';
import 'package:student_clubs_app/screens/create_event.dart';
import 'package:student_clubs_app/screens/create_event_report.dart';
import 'package:student_clubs_app/screens/create_monthly_report.dart';
import 'package:student_clubs_app/screens/events_list.dart';
import 'package:student_clubs_app/screens/my_events.dart';

import '../screens/clubs_list.dart';
import '../screens/my_clubs.dart';
import '../utils/colors.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Appcolors.mainColor,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
                text: "Clubs",
                icon: Icons.people_rounded,
                onClicked: () => selectedItem(context, 0)),
            buildMenuItem(
                text: "Events",
                icon: Icons.event,
                onClicked: () => selectedItem(context, 1)),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Appcolors.textColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
              visible: (6 + 6 == 12), //Eğer öğrenciyse
              child: buildMenuItem(
                  text: "My Clubs",
                  icon: Icons.favorite,
                  onClicked: () => selectedItem(context, 2)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "My Events",
                  icon: Icons.event_available,
                  onClicked: () => selectedItem(context, 3)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Create Event",
                  icon: Icons.create,
                  onClicked: () => selectedItem(context, 4)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Create Event Report",
                  icon: Icons.create,
                  onClicked: () => selectedItem(context, 5)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Create Monthly Report",
                  icon: Icons.create,
                  onClicked: () => selectedItem(context, 6)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Approve Event",
                  icon: Icons.approval,
                  onClicked: () => selectedItem(context, 7)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Add Club",
                  icon: Icons.add,
                  onClicked: () => selectedItem(context, 8)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Apply For Club",
                  icon: Icons.create,
                  onClicked: () => selectedItem(context, 9)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Check Event Reports",
                  icon: Icons.remove_red_eye_outlined,
                  onClicked: () => selectedItem(context, 10)),
            ),
            Visibility(
              visible: (6 + 6 == 12),
              child: buildMenuItem(
                  text: "Check Monthly Reports",
                  icon: Icons.remove_red_eye_outlined,
                  onClicked: () => selectedItem(context, 11)),
            ),
          ],
        ),
      ),
    );
  }

  buildMenuItem(
      { String text,  IconData icon, VoidCallback onClicked}) {
    const color = Appcolors.textColor;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  ClubsList()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const EventsList()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyClubs()));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyEvents()));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateEvent()));
        break;
      case 5:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateEventReport()));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateMonthlyReport()));
        break;
      case 7:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Approve()));
        break;
      case 8:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddClub()));
        break;
      case 9:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ApplyForClub()));
        break;
      case 10:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CheckEventReports()));
        break;
      case 11:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CheckMonthlyReports()));
        break;
    }
  }
}
