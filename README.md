# Raintech Hotel Booking Management Application

A responsive Flutter web and mobile application built for hotel room management, guest check-in/check-out workflows, operational dashboards, and room booking calculation logic.

---

## Tech Stack & Libraries

- **Framework**: Flutter (Dart SDK ^3.12)
- **Routing & Navigation**: `go_router` (^17.5.0)
- **State Management**: `provider` (^6.1.5)
- **Typography & Styling**: `google_fonts` (Inter font family) & Material Design 3
- **Date Formatting**: `intl` (^0.20.3)
- **Data Source**: Static JSON asset (`assets/data.json` & `assets/dat.json`) loaded via `rootBundle`

---

## Features Implemented

### 1. Main Dashboard (`/`)
- **Header**: Hotel brand title ("Raintech HOTEL"), search bar with `Ctrl K` shortcut indicator, live date/time display, quick actions, and profile avatar.
- **Quick Navigation Grid**: 12 modular shortcuts (Guest Check-in, Guest Check-out, Reservations, Housekeeping, Restaurant, WhatsApp, Rooms, Staff, Floors, Reports, Settings, Group Booking).
- **Operational Overview**: Live metrics for Occupancy %, Pending Check-ins/Departures, Total Revenue, and Total Room Count.
- **Interactive Floor View**: Room layout across floors color-coded by real-time status (`Available`, `Occupied`, `Dirty`, `Maintenance`, `Blocked`). Tapping a room tile opens an interactive quick-edit dialog to update room status.
- **Going to Vacate Rooms**: Horizontal card list of upcoming check-outs with guest details.
- **Quick Room Status Changer**: Quick controls to select any room number, toggle status, or set all `Dirty` rooms to `Available`.

### 2. Guest Check-in Workflow (`/check-in`)
- **Step 1 (Select Booking & Guest)**: Search by booking ID/guest name, customer dropdown, add guest button, booking date and time.
- **Step 2 (Review & Update Details)**: Room rate, GST %, tenant name, checkout date picker, ID proof attachment, adult/kid counter, and charge breakdowns.
- **Step 3 (Finalize Check-in & Payment)**: Summary of Room Charge, Extra Charges, Tax, Total Amount, Total Paid, complete check-in trigger, M-Pay, Print, Registration card, and Folio download actions.
- **Check-in Data Table**: Complete tabular list of rooms, rents, GST, guest names, guest counts, senior citizens, checkout dates, ID proofs, and row actions.

### 3. Guest Check-out Workflow (`/check-out`)
- **Step 1 (Identify Departing Guest)**: Search guest name or room number, stay dates table, selection checkboxes for single or multi-room check-out.
- **Step 2 (Review & Finalize Bill)**: Itemized extra charges (Mini-bar, Room Service, Restaurant bills) per room, invoice print/adjust controls, and combined multi-room total calculation.
- **Step 3 (Payment & Check-out)**: Payment method selection (Credit Card, Cash, M-Pay), payment amount input, single or combined check-out triggers, print/email final invoice buttons.

### 4. Room Reservations & Coding Test (`/reservations`)
- **Date Range Picker**: Interactive Check-in date and Check-out date pickers.
- **Date Validations**:
  - Check-in date cannot be in the past.
  - Check-out date must be strictly after Check-in date.
  - Clear, user-friendly error banners displayed for invalid date selections.
- **Guest Capacity Filter**: Filter rooms by minimum guest capacity (2, 3, or 4 guests).
- **Real-Time Price Calculation**: Computes number of stay nights and total reservation price (`nights × price/night`).
- **Room Selection & Confirmation**: Interactive room selector highlighting room code, type, floor, status, max guests, and nightly rate.

---

## Project Structure

```
lib/
├── models/
│   └── room_model.dart          # Room, VacateRoom, CheckoutBill, OperationalMetrics models
├── providers/
│   └── hotel_provider.dart      # Reactive Provider managing room state & data updates
├── repositories/
│   └── hotel_repository.dart    # Asset JSON loader & state mutation logic
├── router/
│   └── app_router.dart          # GoRouter configuration for screens
├── screens/
│   ├── dashboard_screen.dart    # Interactive floor view, quick nav, operational metrics
│   ├── check_in_screen.dart     # 3-step check-in workflow & data table
│   ├── check_out_screen.dart    # 3-step check-out workflow & itemized billing
│   └── reservations_screen.dart # Date picker, date validation & night/price calculator
├── utils/
│   └── booking_calculator.dart  # Business logic for date validation & price calculation
├── widgets/
│   ├── app_header.dart          # Header with logo, search, date/time & actions
│   └── responsive_scaffold.dart # Adaptive navigation shell (Top tab bar / Mobile nav bar)
└── main.dart                    # App entrypoint & MaterialApp.router setup

assets/
├── data.json                    # Primary sample JSON data
└── dat.json                     # Alias JSON asset

test/
├── booking_calculator_test.dart # Unit tests for date validation & pricing logic
└── widget_test.dart             # Smoke test for main application UI
```

---

## How to Run the Project

### Prerequisites
- Flutter SDK (v3.12+ recommended)
- Google Chrome (for web) or iOS/Android emulator

### Steps

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd hotel_bokking_interview
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Web)**:
   ```bash
   flutter run -d chrome
   ```

4. **Run on Mobile / Desktop**:
   ```bash
   flutter run
   ```

---

## Running Unit Tests

Run all unit and widget tests:
```bash
flutter test
```

To run static analysis:
```bash
flutter analyze
```

---
