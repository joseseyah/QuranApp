import SwiftUI

struct DonateView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Support the app")
                    .font(.largeTitle)
                    .padding()

                Text("If you enjoy using this app, consider supporting us by buying a coffee! I do not want users to pay for something Allah has gifted to us. I want this to be accessible as possible. May Allah reward all of us. Ameen")
                    .padding()

                Link("Donate", destination: URL(string: "https://www.buymeacoffee.com/josephhayes")!)
                    .font(.title2)
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
                    .padding()

                Spacer()
            }
            .navigationTitle("Donate")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        DonateView()
    }
}

