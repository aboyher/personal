import SwiftUI

struct ContentView: View {
    @State private var selectedOption = "Cardinals"
    let options = ["Cardinals", "Blues"]
    var body: some View {
        NavigationView {
            if selectedOption == "Cardinals" {
                CardinalsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            PickerNavigationTitleView(selection: $selectedOption, options: options)
                        }
                    }

            } else if selectedOption == "Blues" {
                BluesView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            PickerNavigationTitleView(selection: $selectedOption, options: options)
                        }
                    }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
