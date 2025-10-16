import SwiftUI

struct GridView: View {
    @Binding var tileCount: Int
    let profileData: [(name: String, age: Int)]
    
    var body: some View {
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
    }
}
