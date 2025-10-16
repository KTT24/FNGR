import SwiftUI

struct ChatView: View {
    @Binding var people: [String]
    @Binding var messagesDict: [String: [String]]
    @Binding var currentMessages: [String: String]

    var body: some View {
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
                .onChange(of: messages.count) { _ in
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
