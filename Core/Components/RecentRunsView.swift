import SwiftUI

struct RecentRunsView: View {
    let dateTrainingRun: String
    let timeTrainingRun: String
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "figure.run")
                .font(.title3)
                .fontWeight(.medium)
                .frame(width: 44, height: 44)
                .foregroundStyle(.orange)
                .background(Color.orange.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(dateTrainingRun)
                    .font(.body)
                    .fontWeight(.medium)
                HStack(spacing: 4) {
                    Group {
                        Image(systemName: "clock")
                        Text(timeTrainingRun)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("- km")
                    .font(.body)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

