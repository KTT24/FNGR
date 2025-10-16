import SwiftUI

struct Profile: Decodable {
    let name: String
    let age: Int
    let bio: String
    let image: String
}

struct ProfileView: View {
    @State private var profile: Profile? = nil

    var body: some View {
        VStack(spacing: 20) {
            if let profile = profile {
                Image(profile.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .padding(.top, 20)

                Text(profile.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text("Age: \(profile.age)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Bio")
                        .font(.headline)

                    Text(profile.bio)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                Spacer()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("My Profile")
        .task {
            do {
                if let url = Bundle.main.url(forResource: "profile", withExtension: "json") {
                    let data = try Data(contentsOf: url)
                    let decodedProfile = try JSONDecoder().decode(Profile.self, from: data)
                    profile = decodedProfile
                }
            } catch {
                // Handle error appropriately, for now we just leave profile nil
            }
        }
    }
}

#Preview {
    ProfileView()
}
