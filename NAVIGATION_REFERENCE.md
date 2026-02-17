# Navigation Reference Guide

## Complete Navigation Map for ServiceBook App

```
┌─────────────────────────────────────────────────────────────────┐
│                      MainScreen (Bottom Nav)                    │
└─────────────────────────────────────────────────────────────────┘
         │
         ├── DashboardScreen
         │    ├── ➕ AddServiceScreen (via "Добавить запись")
         │    │    └── 📤 Returns service data
         │    │
         │    ├── 📄 SellReportScreen (via "Отчет для продажи")
         │    │    └── 📊 Shows car condition and value
         │    │
         │    ├── 🚗 PartnersScreen (via "Партнеры СТО")
         │    │    ├── ⏰ Booking dialog (via "Записаться [time]")
         │    │    └── 📦 "Подобрать детали" → Placeholder
         │    │
         │    ├── 📈 ExpenseAnalyticsScreen (via "Аналитика")
         │    │    └── 📊 Shows expense breakdown
         │    │
         │    ├── 📋 AllRecordsScreen (via "Все" buttons)
         │    │    ├── 🔍 Search by title/place
         │    │    ├── 🏷️ Filter by category
         │    │    ├── ↕️ Sort by date/price/mileage
         │    │    └── 📄 Record detail modal
         │    │
         │    └── 🔔 Notifications (placeholder)
         │
         ├── HomeScreen
         │    ├── ➕ AddCarScreen (via FAB)
         │    │    └── 📤 Returns new car data
         │    │
         │    └── 🚗 CarDetailScreen (via car card tap)
         │         ├── 📜 ServiceHistoryScreen (via "История обслуживания")
         │         │    ├── 📄 SellReportScreen (via "Подготовить к продаже")
         │         │    │    └── 📊 PDF generation (TODO)
         │         │    └── 📋 AllRecordsScreen (via "Все записи")
         │         │
         │         ├── 📈 ExpenseAnalyticsScreen (via "Детали")
         │         │    └── 📊 Detailed expense analytics
         │         │
         │         ├── 📄 SellReportScreen (via "Подготовить к продаже")
         │         │    └── 📊 Car sale report
         │         │
         │         ├── 📋 DocumentsScreen (via "СТС")
         │         │    ├── 📄 Driver's License → DriverLicenseScreen
         │         │    ├── 🚗 OSAGO → InsuranceScreen
         │         │    ├── 📄 STS (detail view)
         │         │    ├── 📄 PTS (detail view)
         │         │    └── 📄 Diagnostic Card (detail view)
         │         │         └── ➕ Add new document dialog
         │         │
         │         └── 🚗 InsuranceScreen (via "Оформить")
         │              ├── 📋 Policy type (OSAGO/KASKO)
         │              ├── 📝 Policy number
         │              ├── 🏢 Insurance company
         │              ├── 📅 Date range
         │              └── 📷 Policy photo
         │
         ├── PartnersScreen
         │    ├── ⏰ Booking dialog (via "Записаться [time]")
         │    │    └── ✅ Confirmation dialog
         │    └── 📦 "Подобрать детали" → Placeholder
         │
         └── UserProfileScreen
              ├── ➕ AddCarScreen (via "Добавить")
              │    └── 📤 Returns new car data
              │
              ├── 📋 Driver's License → DriverLicenseScreen
              │    ├── 📷 Front photo
              │    ├── 📷 Back photo
              │    ├── 📝 License number
              │    ├── 📅 Issue date
              │    ├── 📅 Expiry date
              │    └── 🏷️ Categories (A, B, C, D, etc.)
              │
              ├── 🚗 OSAGO → InsuranceScreen
              │    ├── 📋 Policy type (OSAGO/KASKO)
              │    ├── 📝 Policy number
              │    ├── 🏢 Insurance company
              │    ├── 📅 Date range
              │    └── 📷 Policy photo
              │
              ├── 📄 STS → DocumentsScreen
              │    ├── 🏷️ Filter by type
              │    ├── 🏷️ Filter by status
              │    ├── 📄 Document details (modal)
              │    └── ➕ Add new document
              │
              ├── 👤 Personal Data → SettingsScreen
              │
              ├── 💳 Payment Methods → Placeholder ("В разработке")
              │
              ├── ⚙️ App Settings → SettingsScreen
              │    ├── 👤 Edit profile
              │    ├── 🔒 Security
              │    ├── 🔔 Notifications (toggle)
              │    ├── 🌙 Dark mode (toggle)
              │    ├── 🌐 Language (RU/EN)
              │    ├── ☁️ Auto backup (toggle)
              │    ├── 💾 Data management
              │    ├── 💾 Backup history
              │    ├── ❓ Help & FAQ
              │    ├── 💬 Contact support
              │    ├── ⭐ Rate app
              │    ├── 📄 Privacy policy
              │    ├── ⚖️ Terms of service
              │    ├── ℹ️ About app
              │    └── 🚪 Logout
              │
              └── ❓ Help & Support → SupportScreen
                   ├── 📧 Email contact
                   ├── 📞 Phone contact
                   ├── 💬 Chat support form
                   ├── ❓ FAQ section (expandable)
                   ├── 🎥 Video tutorials
                   ├── 📖 User manual
                   └── 📚 Knowledge base
```

---

## Screen List (22 Total)

### New Screens Created (6)
1. **DriverLicenseScreen** - Driver's license management
2. **InsuranceScreen** - Insurance policy management
3. **DocumentsScreen** - Central document hub
4. **SettingsScreen** - App and account settings
5. **AllRecordsScreen** (enhanced) - All service records with filters
6. **SupportScreen** - Help and support center

### Existing Screens (16)
1. **AuthScreen** - Authentication
2. **MainScreen** - Bottom navigation
3. **DashboardScreen** - Dashboard (updated navigation)
4. **HomeScreen** - Car list
5. **AddCarScreen** - Add new car
6. **CarDetailScreen** (updated navigation) - Car details
7. **ServiceHistoryScreen** (updated navigation) - Service history
8. **AddServiceScreen** (updated validation) - Add service record
9. **SellReportScreen** - Sale report
10. **ExpenseAnalyticsScreen** - Expense analytics
11. **PartnersScreen** (updated navigation) - Partner services
12. **UserProfileScreen** (updated navigation) - User profile
13. **ProfileScreen** - Alternative profile
14. **VerificationScreen** - Phone verification
15. **MapScreen** - Map view
16. **AllRecordsScreen** - Original version (replaced)

---

## Navigation Patterns

### Screen Push Navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TargetScreen(),
  ),
);
```

### Screen Push with Data
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TargetScreen(car: carData),
  ),
);
```

### Screen Pop with Data
```dart
Navigator.pop(context, returnValue);
```

### Dialog Navigation
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(...),
);
```

### Bottom Sheet Navigation
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(...),
);
```

---

## Key Features by Screen

### DriverLicenseScreen
- ✅ Front/back photo upload
- ✅ License number input
- ✅ Issue/expiry date pickers
- ✅ Category selection
- ✅ Form validation
- ✅ Loading states

### InsuranceScreen
- ✅ Policy type selection (OSAGO/KASKO)
- ✅ Policy number input
- ✅ Insurance company dropdown
- ✅ Valid from/to date pickers
- ✅ Policy photo upload
- ✅ Form validation
- ✅ Loading states

### DocumentsScreen
- ✅ Document list with status
- ✅ Filter by type
- ✅ Filter by expiry status
- ✅ Add new document dialog
- ✅ Document detail modal
- ✅ Empty state

### SettingsScreen
- ✅ Personal data
- ✅ Notifications toggle
- ✅ Dark mode toggle
- ✅ Language selection
- ✅ Auto backup toggle
- ✅ Data management
- ✅ Support links
- ✅ About app
- ✅ Logout

### AllRecordsScreen (Enhanced)
- ✅ Search functionality
- ✅ Filter by category
- ✅ Sort options
- ✅ Statistics summary
- ✅ Record detail modal
- ✅ Edit/Delete options
- ✅ Empty state

### SupportScreen
- ✅ Contact information
- ✅ FAQ section
- ✅ Chat support form
- ✅ Video tutorials link
- ✅ User manual link
- ✅ Knowledge base link

---

## Common Widget Patterns

### AppBar with Title
```dart
AppBar(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  elevation: 0.5,
  title: const Text(
    'Screen Title',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  centerTitle: true,
)
```

### Standard Card
```dart
Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(...),
)
```

### Standard Button
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF1E88E5),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text('Button Text'),
)
```

### Filter Chip
```dart
FilterChip(
  label: Text('Label'),
  selected: isSelected,
  onSelected: (_) => setState(() {}),
  backgroundColor: Colors.grey.shade100,
  selectedColor: const Color(0xFF1E88E5),
  labelStyle: TextStyle(
    color: isSelected ? Colors.white : Colors.black,
  ),
)
```

---

## Navigation Shortcuts

### Quick Reference
- **Driver's License** → `DriverLicenseScreen`
- **Insurance** → `InsuranceScreen`
- **All Documents** → `DocumentsScreen`
- **Settings** → `SettingsScreen`
- **Support** → `SupportScreen`
- **All Records** → `AllRecordsScreen`
- **Service History** → `ServiceHistoryScreen`
- **Car Details** → `CarDetailScreen`
- **Add Service** → `AddServiceScreen`
- **Add Car** → `AddCarScreen`
- **Partners** → `PartnersScreen`
- **Sell Report** → `SellReportScreen`
- **Analytics** → `ExpenseAnalyticsScreen`

---

## TODO Items for Future

1. Implement actual photo picker using `image_picker`
2. Implement PDF generation for sale reports
3. Connect to backend APIs for data persistence
4. Add push notification integration
5. Add unit and widget tests
6. Improve accessibility support
7. Add full internationalization
8. Implement payment methods screen
9. Implement parts catalog screen
10. Implement notifications screen

---

**Generated**: 2024
**Version**: 1.0.0+1
