# FootballTraining

FootballTraining is a SwiftUI-based iOS application designed to help users manage and track their football training routines. The app provides a structured approach to workouts, allowing users to progress through different phases, weeks, and days of training.

## Features

- **Dynamic Workout Management**: Automatically updates the current phase, week, and day based on completed exercises.
- **Exercise Tracking**: Displays exercises for the day, including sets, reps, and calculated lift intensities.
- **Phase Progression**: Automatically transitions to the next day, week, or phase when workouts are completed.
- **Data Persistence**: Saves and retrieves user progress using SwiftData.
- **Reactive UI**: Updates the workout list and progress in real time as user data changes.
- **Multiple Training Phases**: Supports Postseason, Winter, Spring, Summer, Preseason, and In-Season phases.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **SwiftData**: For data persistence and management.
- **JSON Decoding**: To load workout data from JSON files.
- **EnvironmentObject**: For managing shared state across views.

## File Structure

- `CurrentDayWorkoutView.swift`: Displays and manages the current day's workout, updating as user data changes.
- `ExercisesListView.swift`: Renders the list of exercises for the day.
- `PhaseManager.swift`: Handles phase-related logic and state management.
- `NavigationManager.swift`: Manages navigation between views.
- `PostseasonModel.swift`: Decodes JSON data for workout phases, weeks, and days.
- `ModelUtils.swift`: Utility functions for saving and updating phase progress.

## How It Works

1. **Workout Data**: The app loads workout data from JSON files based on the current phase.
2. **Exercise Display**: Exercises for the day are displayed, including calculated lift intensities based on user maxes.
3. **Progression**: As users complete exercises, the app updates the current day, week, or phase and saves the progress.
4. **Persistence**: User progress is saved using SwiftData for seamless continuity.
5. **Reactive Updates**: The UI updates automatically when user maxes or completion status change.

## Setup and Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ridleytech/FootballTraining.git
   ```
