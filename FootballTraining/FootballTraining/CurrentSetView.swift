//
//  CurrentSetView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import Combine
import SwiftUI

struct CurrentSetView: View {
    @Binding var exerciseName: String
    @State var dayExercises: (text: String, type: String, name: String, sets: [SetElement], max: Double)
    @Binding var lastCompletedItem: Int
    @State var currentSet: Int = 1
    @State var setStarted = false
    @State var workoutStarted = false
    @State private var showAlert = false
    @State private var workoutEnded = false
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var remainingTime: Int = 120 // starting time in seconds (example: 5 minutes)
    @State private var timerRunning = false
    @State private var timerCancellable: Cancellable?

    func completeSet() {
        setStarted = false

        if currentSet == dayExercises.sets.count {
            workoutCompleted()
            return
        }

        currentSet += 1
        startTimer()

        // pause exercise video
    }

    func startSet() {
        setStarted = true
        workoutStarted = true
        resetTimer()

        // start exercise video
    }

    func workoutCompleted() {
        print("workoutCompleted")
        workoutStarted = false
        showAlert = true
        workoutEnded = true
        lastCompletedItem += 1

        // pause exercise video
    }

    private func startTimer() {
        guard !timerRunning else { return }

        timerRunning = true
        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    stopTimer()
                }
            }
    }

    private func stopTimer() {
        timerRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func resetTimer() {
        stopTimer()
        remainingTime = 120 // reset to 5 minutes (or whatever you want)
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return "\(minutes):" + String(format: "%02d", seconds)
    }

    func roundToNearestMultipleOfFive(_ number: Double) -> Double {
//        print("number: \(number)")

        let val = 5 * round(Double(number) / 5.0)

//        print("rounded: \(val)")
        return val
    }

    var body: some View {
//        ZStack {
        VStack {
            Text(exerciseName)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)
            Spacer().frame(height: 20)

            HStack {
                Text("Current Set: ")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.grayColor)
                    + Text("\(currentSet)")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)
                    + Text(" of ")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.grayColor)
                    + Text("\(dayExercises.sets.count)")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)
                //                Spacer()
            }
            Spacer().frame(height: 20)

            if dayExercises.sets.count > 0 && currentSet < dayExercises.sets.count + 1 {
                if dayExercises.max > 0.0 {
                    if let intensityString = dayExercises.sets[currentSet-1].intensity, let reps = dayExercises.sets[currentSet-1].reps {
                        if let intensity = Double(intensityString) {
                            // Calculate real lift amount
                            let calculatedLift = intensity * dayExercises.max
                            let formattedLift = String(format: "%.0f", roundToNearestMultipleOfFive(calculatedLift)) // no decimals
                            Text("\(formattedLift) x \(reps)")
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundColor(AppConfig.greenColor)

                        } else {
                            // fallback to showing raw intensity
                            Text("\(intensityString) x \(reps)")
                        }
                    }
                } else {
                    Text("\(dayExercises.sets[currentSet-1].intensity ?? "") x \(dayExercises.sets[currentSet-1].reps ?? "")")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.greenColor)
                }
            }
            Spacer().frame(height: 10)
            ZStack {
                Spacer()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)))

                //                if (setStarted || !workoutStarted) && !workoutEnded {
                //            Image("ava-logo-bg")
                //                .resizable()
                //                .scaledToFill()
                ////                    .frame(maxWidth: .infinity)
                ////                    .frame(height: 600)
                ////                    .background(Color(UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)))
                //                .opacity(setStarted ? 1.0 : 0.5)

                //                }

                //            Spacer()

                if setStarted {
                    Text("Lift")
                        .font(.system(size: 100, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.grayColor)
                }
            }
            Spacer().frame(height: 10)

            Button(action: {
                //            gotoToMaxHistory = true

                setStarted ? completeSet() : startSet()
            }) {
                Text("\(workoutEnded ? "Lift Completed" : setStarted ? "End Set" : "Start Set")")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(currentSet == dayExercises.sets.count && !workoutStarted ? Color.gray : Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding([.leading, .trailing], 16)
            .disabled(currentSet == dayExercises.sets.count && !workoutStarted)

            Spacer()
        }
        .onAppear {
            print("dayExercises: \(dayExercises)")
            //
            //            if let firstSet = dayExercises.sets.first {
            //                print("First Set: \(String(describing: firstSet.reps))")
            //            }
        }
        .alert("Lift Completed", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                print("go back to workout")
                //                fire event to update current highlighted exercise in list
                //                navigationManager.path.removeLast(2)
            }
        } message: {
            Text("")
        }

        if !setStarted && workoutStarted { Text(timeString(from: remainingTime))
            .font(.system(size: 100, weight: .bold, design: .default))
//            .background(Color.gray)
            .foregroundColor(AppConfig.grayColor)
        }
//        }

//        Spacer()
    }
}

#Preview {
    let sampleSet = SetElement(
        name: "1",
        intensity: "0.75",
        reps: "8",
        time: "2:00",
        rest: "90"
    )

    let sampleSet2 = SetElement(
        name: "2",
        intensity: "0.80",
        reps: "8",
        time: "2:00",
        rest: "90"
    )

    let sampleSet3 = SetElement(
        name: "2",
        intensity: "0.80",
        reps: "8",
        time: "2:00",
        rest: "90"
    )

    let sampleSet4 = SetElement(
        name: "2",
        intensity: "0.80",
        reps: "8",
        time: "2:00",
        rest: "90"
    )

    CurrentSetView(exerciseName: .constant("Bench Press"), dayExercises: (text: "String", type: "String", name: "String", sets: [sampleSet, sampleSet2, sampleSet3], max: 0.0), lastCompletedItem: .constant(-1))
        .environmentObject(NavigationManager())
}

// var name: String
// var intensity: String?
// var reps: String?
// var time: String?
// var rest: String?
