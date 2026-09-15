import SwiftUI

struct WelcomeView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("welcome.main.title")
                    Text("welcome.main.title.appName")
                        .foregroundStyle(.tint)
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
                Text("welcome.continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 50)
            
        }.padding(.horizontal, 25)
    }
    
    
}
