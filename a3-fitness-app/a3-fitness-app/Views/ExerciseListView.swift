// ExerciseListView.swift

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var userManager: UserManager
    @State private var apiExercises: [Exercise] = []
    @State private var isLoading = false

    var body: some View {
        List {
            if !userManager.user.exercisePool.isEmpty {
                Section("Your Exercises") {
                    ForEach(userManager.user.exercisePool) { ex in
                        HStack {
                            AsyncImage(url: URL(string: ex.gifUrl)) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable()
                                       .scaledToFill()
                                       .frame(width: 50, height: 50)
                                       .clipped()
                                       .cornerRadius(6)
                                default:
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            Text(ex.name)
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteFromPool)
                }
            }

            Section("Discover More") {
                ForEach(apiExercises) { ex in
                    HStack {
                        AsyncImage(url: URL(string: ex.gifUrl)) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable()
                                   .scaledToFill()
                                   .frame(width: 50, height: 50)
                                   .clipped()
                                   .cornerRadius(6)
                            default:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        Text(ex.name)
                            .font(.subheadline)
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
        .listStyle(.insetGrouped)
        .navigationTitle("Exercises")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isLoading {
                    ProgressView()
                } else {
                    Button {
                        Task { await loadExercises() }
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
        }
        .task { await loadExercises() }
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
        guard !userManager.user.exercisePool.contains(ex) else { return }
        userManager.user.exercisePool.append(ex)
        userManager.saveUser()
    }

    private func deleteFromPool(at offsets: IndexSet) {
        userManager.user.exercisePool.remove(atOffsets: offsets)
        userManager.saveUser()
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(userManager: UserManager())
    }
}
