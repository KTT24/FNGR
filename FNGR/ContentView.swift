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
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<min(tileCount, profileData.count), id: \.self) { index in
                        ZStack(alignment: .bottom) {
                            Image("\(index % 7)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            HStack(spacing: 0) {
                                Text("\(profileData[index].age)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 3)
                                    .background(Color.black.opacity(0.6))
                                
                                Text(profileData[index].name)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 3)
                                    .background(Color.black.opacity(0.6))
                            }
                        }
                        .onAppear {
                            if index == tileCount - 1 {
                                tileCount += 30
                            }
                        }
                    }
                }
                .padding()
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Grid")
            }
            
            // Chat Tab
            NavigationStack {
                List(people, id: \.self) { person in
                    NavigationLink(destination: {
                        let messagesBinding = Binding<[String]>(
                            get: { messagesDict[person, default: []] },
                            set: { messagesDict[person] = $0 }
                        )
                        let currentMessageBinding = Binding<String>(
                            get: { currentMessages[person, default: ""] },
                            set: { currentMessages[person] = $0 }
                        )
                        ChatDetailView(
                            person: person,
                            messages: messagesBinding,
                            currentMessage: currentMessageBinding
                        )
                    }) {
                        HStack {
                            Image("0")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                            Text(person)
                        }
                    }
                }
                .navigationTitle("Chats")
            }
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

struct ChatDetailView: View {
    let person: String
    @Binding var messages: [String]
    @Binding var currentMessage: String

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(messages.indices, id: \.self) { idx in
                            Text(messages[idx])
                                .padding(10)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(idx)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    if !messages.isEmpty {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField("Message", text: $currentMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    let trimmed = currentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        messages.append(trimmed)
                        currentMessage = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .padding(.leading, 4)
            }
            .padding([.horizontal, .bottom])
        }
        .navigationTitle(person)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
