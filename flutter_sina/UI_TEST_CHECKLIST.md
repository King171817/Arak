# Flutter Sina Modular UI Test Checklist

## 1. Student: admin / 1234

Expected:
- Login opens student panel.
- Bottom navigation shows:
  - Dashboard
  - Classes
  - Units
  - Requests
  - Services
  - Settings
- Dashboard opens weekly schedule.
- Classes shows weekly class schedule.
- Units shows university units.
- Requests allows creating a new ticket.
- Services shows full student services:
  - Money exchange
  - Hotel
  - Taxi
  - Translation
  - Air ticket
  - Courses
  - Printing
  - Welfare
- Settings changes language to Persian, English, Arabic.

Check:
- Arabic changes direction to RTL.
- Floating announcement can be dismissed by click/tap.

---

## 2. Professor: prof1 / 1234

Expected:
- Login opens professor panel.
- Bottom navigation shows:
  - Dashboard
  - Classes
  - Managers Chat
  - Requests
  - Services
  - More
- Classes shows professor classes.
- Managers Chat can send messages to managers and sina.
- Services shows only staff services:
  - Translation
  - Printing
  - Welfare

---

## 3. Education Manager: admin2 / 1234

Expected:
- Login opens education manager panel.
- Bottom navigation shows:
  - Dashboard
  - Classes
  - Students
  - Officers
  - Requests
  - Reports
  - Managers Chat
  - Services
- Classes allows:
  - Create class
  - Select professor
  - Select students
  - Select day and time
  - Add student to existing class
  - Remove student from class
- Students opens student full file.
- Student file includes:
  - Profile
  - Courses/classes
  - Weekly schedule
  - Education report
  - Finance status, read-only
  - Discipline report, read-only
- Officers allows managing education officer permissions.
- Reports opens past class reports with filters.
- Requests allows changing ticket status.

---

## 4. Education Officer: edu_officer1 / 1234

Expected:
- Login opens education panel.
- Access depends on permissions.
- Can see education-related classes/reports if permission exists.
- Should not have super admin controls.

---

## 5. Super Admin: sina / 1234

Expected:
- Login opens super admin control center.
- Can manage:
  - Floating announcement
  - Floating announcement target group
  - Floating announcement duration
  - Logo
  - Background
  - Maintenance mode
  - Registration toggle
  - Locks for user, role, unit, section
  - Reports
  - Managers chat
  - Requests
- If maintenance mode is on:
  - sina can still enter.
  - normal users see maintenance screen.

---

## 6. Section Lock Tests

Use sina to add section locks:

- classes
- services
- units
- settings
- tickets
- reports
- students
- officers
- messages

Expected:
- Locked section disappears from bottom navigation.
- Dashboard quick access should not open locked section.

---

## 7. Language Tests

Test Persian:
- RTL layout.
- Persian labels.

Test Arabic:
- RTL layout.
- Arabic labels where defined.

Test English:
- LTR layout.
- English labels.

---

## 8. Final Notes

If any screen crashes:
- Copy the red error from Chrome/terminal.
- Send the first 20 lines of the error.
- Mention which login account and which tab caused it.
