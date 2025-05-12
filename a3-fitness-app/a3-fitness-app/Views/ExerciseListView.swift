// ExerciseListView.swift

import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var apiExercises: [Exercise] = []
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List {
                // "Your Exercises" section
                if !userManager.user.exercisePool.isEmpty {
                    Section(header: Text("Your Exercises")) {
                        ForEach(userManager.user.exercisePool) { ex in
                            HStack {
//                                AsyncImage(url: URL(string: ex.gifUrl)) { phase in
//                                    switch phase {
//                                    case .success(let img):
//                                        img.resizable()
//                                            .scaledToFill()
//                                            .frame(width: 50, height: 50)
//                                            .clipped()
//                                            .cornerRadius(6)
//                                    default:
//                                        ProgressView()
//                                            .frame(width: 50, height: 50)
//                                    }
//                                }
                                Text(ex.name)
                                    .font(.headline)
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteFromPool)
                    }
                }
                
                // "Discover More" section
                Section(header: Text("Discover More")) {
                    ForEach(apiExercises) { ex in
                        HStack {
//                            AsyncImage(url: URL(string: ex.gifUrl)) { phase in
//                                switch phase {
//                                case .success(let img):
//                                    img.resizable()
//                                        .scaledToFill()
//                                        .frame(width: 50, height: 50)
//                                        .clipped()
//                                        .cornerRadius(6)
//                                default:
//                                    ProgressView()
//                                        .frame(width: 50, height: 50)
//                                }
//                            }
                            Text(ex.name)
                                .font(Font.custom("ZenDots-Regular", size: 15))
                            
                            Spacer()
                            Button {
                                addToPool(ex)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped) // Style for the list
            .navigationTitle("Exercises")
            .task { await loadExercises() } // Task to load exercises
        }
    }

    // MARK: - API

    private func loadExercises() async {
        isLoading = true
        do {
            apiExercises = try await fetchExercises(limit: 20)  // calls your global func
        } catch {
            print("❌ fetchExercises failed:", error)
        }
        isLoading = false
    }

    // MARK: - Pool management

    private func addToPool(_ ex: Exercise) {
        print("Ran addToPool")
        guard !userManager.user.exercisePool.contains(ex) else { return }
        print("Exercise not found in pool")
        userManager.user.exercisePool.append(ex)
        print("Exercise appended to userManager")
        userManager.saveUser()
        print("User saved!")
    }

    private func deleteFromPool(at offsets: IndexSet) {
        userManager.user.exercisePool.remove(atOffsets: offsets)
        userManager.saveUser()
    }
}

#Preview {
    ExerciseListView()
        .environmentObject(UserManager())
}
