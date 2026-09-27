import SwiftUI

struct ParchmentListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
//            .background(EnchantedTheme.paleGold)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func parchmentStyle() -> some View {
        self.modifier(ParchmentListStyle())
    }
}

struct ParchmentListBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
//                    .fill(EnchantedTheme.paleGold)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
    }
}

extension View {
    func parchmentBackgroundStyle() -> some View {
        self.modifier(ParchmentListBackgroundStyle())
    }
}
