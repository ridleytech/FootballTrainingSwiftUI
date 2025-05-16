//
//  CurrentSetView.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import AVFoundation
import Combine
import SwiftUI

class SoundManager: ObservableObject {
    var player: AVAudioPlayer?

    func loadSound(_ name: String, ext: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.75

//            print("player loaded")

        } catch {
            print("player load failed: \(error)")
        }
    }

    func playSound() {
        player?.play()
    }

    func stopSound() {
        player?.stop()
    }
}

struct CurrentSetView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: PhaseViewModel
    @StateObject var sound = SoundManager()

//    @State var selectedExercise: DayExercise
    @State var currentSet: Int = 1
    @State var setStarted = false
    @State var workoutStarted = false
    @State private var showAlert = false
    @State private var workoutEnded = false

    @State private var exerciseRestTime: Int = 120
    @State private var remainingTime: Int = 120 // starting time in seconds (example: 5 minutes)
    @State private var timerRunning = false
    @State private var timerCancellable: Cancellable?
    @State private var audioPlayer: AVAudioPlayer?

    func completeSet() {
        setStarted = false

        if currentSet == viewModel.selectedExercise.sets.count {
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
        viewModel.lastCompletedItem += 1

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

                    if remainingTime == 3 {
                        print("play countdown sound")

                        sound.playSound()
                    }
                } else {
                    stopTimer()

                    if viewModel.selectedExercise.sets.count > 0 && currentSet < viewModel.selectedExercise.sets.count + 1 {
                        startSet()
                    }
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
        remainingTime = exerciseRestTime
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return "\(minutes):" + String(format: "%02d", seconds)
    }

    var body: some View {
        VStack {
            Text(viewModel.selectedExercise.name)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(AppConfig.greenColor)
            Spacer().frame(height: 20)

            HStack {
                Text("Set: ")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.grayColor)
                    + Text("\(currentSet)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)
                    + Text(" of ")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.grayColor)
                    + Text("\(viewModel.selectedExercise.sets.count)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)
                //                Spacer()
            }
            Spacer().frame(height: 10)

            if viewModel.selectedExercise.sets.count > 0 && currentSet < viewModel.selectedExercise.sets.count + 1 {
                if viewModel.selectedExercise.max > 0.0 {
                    if let intensityString = viewModel.selectedExercise.sets[currentSet-1].intensity, let reps = viewModel.selectedExercise.sets[currentSet-1].reps {
                        if let intensity = Double(intensityString) {
                            // Calculate real lift amount
                            let calculatedLift = intensity * viewModel.selectedExercise.max
                            let formattedLift = String(format: "%.0f", Utils.roundToNearestMultipleOfFive(calculatedLift)) // no decimals
                            Text("\(formattedLift) x \(reps)")
                                .font(.system(size: 50, weight: .bold, design: .default))
                                .foregroundColor(AppConfig.greenColor)

                        } else {
                            // fallback to showing raw intensity
                            Text("\(intensityString) x \(reps)")
                        }
                    }
                } else {
                    Text("\(viewModel.selectedExercise.sets[currentSet-1].intensity ?? "") x \(viewModel.selectedExercise.sets[currentSet-1].reps ?? "")")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundColor(AppConfig.greenColor)
                }
            }
            Spacer().frame(height: 10)
            ZStack {
//                Spacer()
//                    .frame(maxWidth: .infinity)
//                    .background(Color(UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 1.0)))

                VStack {
                    Spacer()
                    Image("AppIconSplash")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .opacity(setStarted ? 1.0 : 0.25)
                    //                    .scaledToFill()
                    //                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(AppConfig.greenColor)
                .opacity(0)
            }
            Spacer().frame(height: 10)

            Button(action: {
                setStarted ? completeSet() : startSet()
            }) {
                Text("\(workoutEnded ? "Lift Completed" : setStarted ? "End Set" : "Start Set")")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(currentSet == viewModel.selectedExercise.sets.count && !workoutStarted ? Color.gray : Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .disabled(currentSet == viewModel.selectedExercise.sets.count && !workoutStarted)

            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            print("viewModel.selectedExercise: \(viewModel.selectedExercise)")

            if let firstSet = viewModel.selectedExercise.sets.first {
                print("First Set: \(firstSet.description)")
            }

            print(viewModel.selectedExercise.type)

            sound.loadSound("countdown-beep", ext: "wav")

            if viewModel.selectedExercise.type == "Basic" {
                exerciseRestTime = 120
            } else {
                exerciseRestTime = 90
            }

            remainingTime = exerciseRestTime

//            loadPlayer(named: "countdown-beep")
        }
        .onChange(of: exerciseRestTime) { newVal in
            print("exerciseRestTime: \(newVal)")
        }
        .onDisappear {
            sound.stopSound()
            stopTimer()
        }
        .alert("Lift Completed", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                print("go back to workout")
                // fire event to update current highlighted exercise in list
                navigationManager.path.removeLast(2)
            }
        } message: {
            Text("")
        }

        if !setStarted && workoutStarted && remainingTime > 0 { Text(timeString(from: remainingTime))
            .font(.system(size: 100, weight: .bold, design: .default))
//            .background(Color.gray)
            .foregroundColor(AppConfig.grayColor)
        }
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

    CurrentSetView(
        //        selectedExercise: DayExercise(text: "String", type: "String", name: "String", sets: [sampleSet, sampleSet2, sampleSet3], max: 0.0)
    )
    .environmentObject(NavigationManager())
}

// var name: String
// var intensity: String?
// var reps: String?
// var time: String?
// var rest: String?
