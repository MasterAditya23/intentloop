IntentLoop 🧠⏳

Break the scroll. Own your time.

IntentLoop is an intention-first digital wellbeing Android application that helps users become more mindful of how they use social media and other distracting apps.

Instead of relying only on screen-time statistics or rigid app blocking, IntentLoop introduces mindful friction: a moment of awareness that helps users remember why they opened an app, define how long they intend to use it, and make a conscious choice about their time.

Built with Flutter and Dart, IntentLoop combines Android app-usage monitoring, local notifications, intentional session planning, and on-device session history in one privacy-focused experience.

📌 Table of Contents

The Problem

Our Solution

Key Features

How IntentLoop Works

What Makes IntentLoop Different

Technology Stack

Project Architecture

Getting Started

Android Permissions and Setup

Privacy and Data Storage

Current Scope and Future Possibilities

Limitations

Contributing

License

🎯 The Problem

Have you ever opened Instagram to reply to one message, only to find yourself scrolling Reels several minutes later?

Or opened YouTube to watch one useful video and continued watching unrelated videos long after you had finished what you originally intended to do?

These experiences illustrate a common challenge: we can lose track of our original intention while using our phones.

Traditional digital-wellbeing tools often emphasize:

Screen-time reports and usage statistics.

App timers and usage limits.

Scheduled restrictions and app blocking.

These tools can be useful, but they do not always connect app usage with the user's immediate purpose.

IntentLoop explores a complementary approach: helping people remember what they intended to do before their usage becomes unintentional.

💡 Our Solution

IntentLoop connects three things:

Intention: Why are you opening this app?

Time: How long do you plan to spend?

Reflection: Did your actual session match your intention?

Through session planning, app-usage detection, and mindful notifications, IntentLoop encourages users to pause and make a conscious decision.

Our philosophy is simple:

We don't want to control your phone. We want to help you take control of your choices.

IntentLoop is designed to complement digital-wellbeing tools, not claim to replace every existing screen-time solution.

✨ Key Features

1. 📱 App-Usage Detection

IntentLoop uses Android's Usage Stats functionality to obtain app-usage information and identify supported applications, such as Instagram and YouTube.

When supported app usage is detected, IntentLoop can guide the user into its session-planning experience.

Detection depends on the required Android permission and the operating system's background-execution behavior.

2. 🔔 Mindful Notifications

IntentLoop uses local notifications to remind users about their intentions.

A mindful reminder might say:

IntentLoop — Mindful Check-in

Hey buddy, what did you come here to do? Take a moment to remember your intention.

The goal is to encourage awareness without shaming the user or automatically treating all social-media use as harmful.

3. ⏳ Intention-Based Session Planning

Users can define a session by selecting:

A target application.

Their specific intention.

Their intended duration.

This turns an ordinary app-use session into a purposeful activity with a clear goal.

4. 🎯 Meaningful Session Choices

IntentLoop emphasizes conscious choices instead of relying solely on forced restrictions.

During an active session, users can choose to:

Complete the session: Declare that they have done what they needed to do.

Extend by 5 minutes: Continue intentionally when more time is needed.

End early: Finish the session before the planned duration.

The session outcome is saved so the user can review their progress later.

5. 📊 Mindful Score

IntentLoop includes a dashboard that tracks session outcomes.

The current score is based on intentions kept relative to the total number of recorded sessions.

The purpose is to make progress understandable and encourage users to reflect on their habits.

6. 📈 Mindfulness Rate

The history screen presents a summary of recorded session outcomes, including a mindfulness percentage and a chronological session history.

The percentage is intended to show how often users complete their intended sessions. It is a self-tracking indicator, not a clinical measurement of mindfulness.

7. 📅 Daily Reminders

Users can configure a daily reminder to plan their activities and approach phone usage more intentionally.

Local notification scheduling is designed to work without a cloud notification server. Actual delivery can depend on notification permissions, Android scheduling behavior, and device settings.

8. 🔐 Local-First Data Storage

IntentLoop stores session information locally using shared_preferences.

The current implementation is designed to operate without requiring a remote backend for its core features. This reduces dependence on network connectivity and avoids the need to upload session history to a server.

🔄 How IntentLoop Works

The intended user journey is straightforward.

Step 1 — Detect supported app usage

IntentLoop obtains app-usage information through Android's Usage Stats functionality, subject to the permissions and monitoring configuration.

Step 2 — Prompt the user to plan

When the detection workflow is triggered, IntentLoop can bring the user into the session-planning experience.

Step 3 — Define an intention

The user chooses what they want to accomplish and how much time they intend to spend.

For example:

App: Instagram

Intention: Reply to messages

Planned duration: 5 minutes

Step 4 — Start the session

IntentLoop records the session information and displays the active session interface.

Step 5 — Make a conscious choice

The user can complete the session, request an additional five minutes, or end the session early.

Step 6 — Save and review

The final session outcome is stored locally and can be displayed in the history and analytics screens.

Step 7 — Build awareness over time

By reviewing previous sessions and the Mindful Score, users can reflect on how often their app usage matches their intentions.

🌟 What Makes IntentLoop Different?

Conventional approach

IntentLoop's approach

Emphasizes total screen time

Connects usage with a stated intention

May rely on strict limits or blocking

Encourages conscious decisions

Focuses on usage reports

Tracks the outcomes of planned sessions

Treats time as the primary metric

Considers both purpose and intended duration

Can emphasize restriction

Emphasizes awareness and user choice

IntentLoop's distinctive idea is intention-first intervention.

We are exploring whether connecting a user's purpose with their app-use session can make digital-wellbeing tools feel more personal and useful.

Rather than claiming that this approach is already proven to reduce excessive scrolling, we aim to build and evaluate a practical prototype around that idea.

🛠️ Technology Stack

Technology

Purpose

Flutter

Cross-platform application UI framework

Dart

Main application programming language

Android Usage Stats

Provides app-usage information

flutter_background_service

Background monitoring service implementation

usage_stats

Access to Android usage statistics

flutter_local_notifications

Local notifications and reminders

timezone

Timezone-aware notification scheduling

shared_preferences

Local persistence of session data

Git and GitHub

Version control and source-code hosting

The project uses Android-specific capabilities for app-usage monitoring and background execution while using Flutter for the application interface.

🏗️ Project Architecture

The codebase is organized into screens, models, and services to separate the user interface from the underlying application logic.

intentloop/
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   └── session.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── session_setup_screen.dart
│   │   ├── active_session_screen.dart
│   │   └── history_screen.dart
│   │
│   └── services/
│       ├── app_mapper.dart
│       ├── notification_service.dart
│       ├── storage_service.dart
│       └── usage_service.dart
│
├── android/
├── pubspec.yaml
└── README.md

What each component does

main.dart — Application entry point

Initializes the Flutter application and configures its startup flow.

models/session.dart — Session data model

Defines the structure used to represent a session, including its intention, target app, timestamps, planned duration, and outcome fields.

screens/home_screen.dart — Home dashboard

Displays the main interface, Mindful Score, and primary navigation and actions.

screens/session_setup_screen.dart — Session planning

Allows users to specify the target app, intention, and planned duration.

screens/active_session_screen.dart — Active session

Displays the session timer and provides options to complete, extend, or end the session.

screens/history_screen.dart — History and analytics

Shows previously recorded sessions and summarizes their outcomes.

services/usage_service.dart — App-usage information

Handles access to app-usage information used by the detection workflow.

services/app_mapper.dart — App identification

Converts supported Android package identifiers into readable application names.

services/notification_service.dart — Notifications

Manages local notification functionality and reminder scheduling.

services/storage_service.dart — Local persistence

Saves and retrieves recorded session information on the device.

Background monitoring

The background monitoring implementation uses flutter_background_service alongside Android app-usage functionality. This separates monitoring work from the main Flutter screen's lifecycle.

Background operation remains subject to Android permissions, operating-system restrictions, and device-specific battery management.

🚀 Getting Started

Follow these steps to run IntentLoop on a compatible Android device.

Prerequisites

Install or prepare:

Flutter SDK.

Dart SDK, normally included with Flutter.

Android Studio or the required Android SDK tools.

Visual Studio Code with the Flutter and Dart extensions.

Git.

An Android phone with USB debugging enabled, or a compatible emulator.

A physical Android device is recommended because app-usage monitoring and background behavior may not be accurately represented by every emulator.

Step 1 — Clone the repository

Open a terminal in VS Code and run:

git clone <YOUR_INTENTLOOP_GITHUB_REPOSITORY_URL>

Replace the placeholder with the actual GitHub repository URL.

Then enter the project directory:

cd intentloop

If the cloned repository uses a different folder name, enter that directory instead.

Step 2 — Check your Flutter installation

Run:

flutter doctor

Review the output and resolve any required Android toolchain issues.

Step 3 — Install project dependencies

Run:

flutter pub get

This downloads the packages declared in pubspec.yaml.

Step 4 — Connect an Android device

Enable Developer Options and USB debugging on your Android phone, connect it to your computer, and authorize the computer when prompted.

Check whether Flutter detects the device:

flutter devices

Step 5 — Launch the application

From the project directory, run:

flutter run

Flutter will build and launch the app on the selected device.

For the most reliable reproduction of the current project state, use the project's committed dependency configuration and Android build files.

🔑 Android Permissions and Setup

IntentLoop requires certain Android permissions to support its features.

Usage Access

App-usage detection requires the user to grant the relevant Android Usage Access permission.

Open IntentLoop.

Find the Usage Access or monitoring permission action.

Open the Android settings page when prompted.

Locate IntentLoop in the list of apps.

Grant Usage Access.

Return to IntentLoop and verify the monitoring status.

The exact settings labels can vary by Android version and device manufacturer.

Notifications

Allow IntentLoop to send notifications when Android requests notification permission or when permission needs to be enabled through system settings.

Background monitoring

The background monitoring service requires the relevant Android service configuration and permissions.

Some devices may restrict background activity through battery-management settings. If monitoring is interrupted, review the app's permission status and device-specific background settings.

Daily reminders

Scheduled notifications may depend on notification permission, the Android version, alarm scheduling behavior, and device settings.

For this reason, notification scheduling should be verified on the target device rather than assumed to work identically on every Android phone.

🔒 Privacy and Data Storage

IntentLoop follows a local-first design philosophy.

Session data is stored locally using shared_preferences.

The core experience does not require a remote backend.

App-usage monitoring depends on Android permissions granted by the user.

Notification delivery is handled locally by the application.

The current session history is capped at the 20 most recent sessions.

IntentLoop does not need a cloud server to perform its core session-planning workflow.

Local-first storage reduces unnecessary data transmission, but it is not the same as encrypted storage. Users should understand that app-usage monitoring requires sensitive permissions and should be able to disable monitoring and reminders.

🧭 Current Scope and Future Possibilities

The current prototype focuses on demonstrating the core intention-based experience.

Possible future improvements include:

1. More personalized interventions

Explore reminders that respond to a user's active intention and session context.

2. Improved analytics

Provide more meaningful comparisons between planned and actual session duration when reliable measurements are available.

3. Mindful progress and milestones

Develop optional progress milestones that encourage consistency without punishing missed days.

4. Broader app support

Evaluate support for additional applications while keeping app selection configurable and user-controlled.

5. Optional AI-powered reflections

Explore summaries of locally recorded session patterns to help users reflect on their habits.

6. Optional backend integration

Consider synchronization or additional services only if future requirements justify the extra complexity.

These are potential development directions, not claims that the features are already implemented.

⚠️ Limitations

IntentLoop is a prototype and has limitations that should be considered.

App detection requires Usage Access permission.

Background monitoring may be affected by Android restrictions and manufacturer-specific battery management.

Notification delivery depends on permissions and operating-system scheduling behavior.

The Mindful Score is a self-tracking indicator, not a medical or clinical assessment.

Local session history is limited to the most recent 20 sessions.

The prototype does not claim to prevent all unintentional scrolling or guarantee behavior change.

Our focus is to build a reliable, respectful, intention-first experience and evaluate how useful it is to real users.

🤝 Contributing

Contributions, suggestions, and feedback are welcome.

If you would like to improve IntentLoop:

Fork the repository.

Create a feature branch.

Make a focused change.

Test the change on a compatible environment.

Submit a pull request explaining the improvement.

Please avoid introducing unnecessary dependencies or changes that compromise the current working functionality.

📄 License

A license has not been specified in this README.

Before publishing or accepting external contributions, add an appropriate open-source license if you intend to make the project available under those terms.

💙 Our Vision

We believe digital wellbeing should not be only about counting minutes or restricting access.

It should also help people understand their intentions and make conscious decisions about how they spend their time.

IntentLoop — Break the scroll. Own your time.