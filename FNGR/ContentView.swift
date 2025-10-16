//
//  ContentView.swift
//  FNGR
//
//  Created by Kutter Thornton on 10/8/25.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var tileCount = 30
    
    @State private var people = ["Alice", "Bob", "Charlie"]
    @State private var messagesDict: [String: [String]] = ["Alice": [], "Bob": [], "Charlie": []]
    @State private var currentMessages: [String: String] = ["Alice": "", "Bob": "", "Charlie": ""]
    
    // Sample data for names and ages
    private let profileData: [(name: String, age: Int)] = [
        ("Alice", 25), ("Bob", 30), ("Charlie", 28), ("David", 22), ("Emma", 27),
        ("Frank", 35), ("Grace", 29), ("Hannah", 24), ("Ian", 31), ("Julia", 26),
        ("Kevin", 33), ("Lily", 23), ("Mike", 32), ("Nina", 28), ("Oliver", 29),
        ("Patricia", 34), ("Quinn", 27), ("Rachel", 25), ("Sam", 30), ("Tina", 26),
        ("Uma", 28), ("Victor", 31), ("Wendy", 29), ("Xavier", 24), ("Yara", 27),
        ("Zoe", 32), ("Adam", 30), ("Bella", 25), ("Chris", 28), ("Diana", 26)
    ]
    
    var body: some View {
        TabView {
            // Grid Tab
            GridView(tileCount: $tileCount, profileData: profileData, tileCountBinding: $tileCount)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Grid")
                }
            
            // Chat Tab
            ChatView(people: $people, messagesDict: $messagesDict, currentMessages: $currentMessages)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            // Profile Tab
            NavigationStack {
                VStack(spacing: 20) {
                    Image("0")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .padding(.top, 20)
                    
                    Text("John Doe")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Age: 25")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Bio")
                            .font(.headline)
                        
                        Text("Hi, I'm John! I'm passionate about photography, travel, and technology. When I'm not coding or exploring new places, you can find me capturing moments through my camera lens.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle("My Profile")
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Me")
            }
            
            // Settings Tab
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: .constant(false))
                }
                Section(header: Text("Account")) {
                    NavigationLink("Manage Account", destination: Text("Account Details"))
                    Button("Sign Out") {
                        // Sign out action placeholder
                    }
                    .foregroundColor(.red)
                }
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
