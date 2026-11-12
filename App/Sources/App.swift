import SwiftUI
import UIKit

@main
struct WraithgramTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    private var version: String {
        let info = Bundle.main.infoDictionary
        let v = info?["CFBundleShortVersionString"] as? String ?? "?"
        let b = info?["CFBundleVersion"] as? String ?? "?"
        return "\(v) (\(b))"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.04, blue: 0.07),
                    Color(red: 0.12, green: 0.09, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("\u{1F47B}")
                    .font(.system(size: 100))
                    .shadow(color: Color.purple.opacity(0.85), radius: 30)

                Text("Wraithgram")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Тестовая сборка IPA")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))

                VStack(spacing: 8) {
                    row("Версия", version)
                    row("iOS", UIDevice.current.systemVersion)
                    row("Устройство", UIDevice.current.model)
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.07))
                )
                .padding(.top, 12)
            }
            .padding(28)
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).foregroundColor(.white.opacity(0.55))
            Spacer(minLength: 12)
            Text(value).foregroundColor(.white)
        }
        .font(.system(size: 15, design: .rounded))
    }
}
