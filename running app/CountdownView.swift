import SwiftUI

struct CountdownView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var count: Int = 3

    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }.padding()
                
                Spacer()
                
                Text("\(count)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    
                Spacer()
            }
        }
        .task {
            await runCountdown()
        }
    }
    
    private func runCountdown() async {
        while count > 0 {
            do {
                try await Task.sleep(for: .seconds(1))
                count -= 1
            } catch {
                return
            }
        }
        
        onFinished()
    }
}
