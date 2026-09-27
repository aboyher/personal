import SwiftUI

struct EntryRowView: View {
    let entry: Entry
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.crop?.name ?? "Crop")
                    .fontWeight(.bold)
                Text("@GardenApp")
                    .foregroundColor(.secondary)
                Spacer()
                Text(timeAgo(entry.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if entry.type == .note {
                Text(entry.content)
            } else if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                if let caption = entry.caption {
                    Text(caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    Image(systemName: "bubble.left")
                        .foregroundColor(.secondary)
                }
                Button(action: {}) {
                    Image(systemName: "arrow.2.squarepath")
                        .foregroundColor(.secondary)
                }
                Button(action: { isLiked.toggle() }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .secondary)
                }
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    EntryRowView(entry: Entry(timestamp: Date(), type: .note, content: "Example note content"))
}
