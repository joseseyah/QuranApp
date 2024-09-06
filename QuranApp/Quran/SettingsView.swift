import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showingDonateSheet = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                    }
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Joseph Hayes")
                    }
                }
                Section(header: Text("Support")) {
                    Button(action: {
                        showingDonateSheet.toggle()
                    }) {
                        HStack {
                            Text("Donate")
                            Spacer()
                            Text("Joseph Hayes")
                        }
                    }
                    Button(action: {
                        // Open email client with pre-filled recipient email
                        let recipientEmail = "joseph.hayes003@gmail.com"
                        if let url = URL(string: "mailto:\(recipientEmail)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Email Developer")
                            Spacer()
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            // Update the interface style based on isDarkMode
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
        .onChange(of: isDarkMode) { _ in
            // Update the interface style when dark mode toggle changes
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
        .sheet(isPresented: $showingDonateSheet) {
            DonateView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
