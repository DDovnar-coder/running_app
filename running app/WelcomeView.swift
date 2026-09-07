import SwiftUI

struct WelcomeView: View {
//    var onContinue: () -> Void
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("welcome.main.title")
                    Text("welcome.main.title.appName")
                        .foregroundColor(Color(hex: "0A84FF"))
                }
                .font(.largeTitle)
                .bold()
                Text("welcome.main.description")
                    .font(.body)
            }.padding(.top, 25)
              
            
            
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(icon: "figure.run", title: "welcome.feature.run.title", description: "welcome.feature.run.description")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "welcome.feature.progress.title", description: "welcome.feature.progress.description")
                FeatureRow(icon: "target", title: "welcome.feature.goals.title", description: "welcome.feature.goals.description")
            }.padding(.top, 80)
            
            Spacer()
            
            Button(action: {
                router.completeWelcome()
            }) {
                PrimaryButtonLabel(title: "welcome.continue")
            }
            .buttonStyle(.plain)
            .padding(.bottom, 50)
            
        }.padding(.horizontal, 25)
    }
    
    
}

#Preview {
    WelcomeView()
}
