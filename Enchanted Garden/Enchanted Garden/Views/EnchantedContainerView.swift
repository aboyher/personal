//
//  EnchantedContainerView.swift
//  Enchanted Garden
//
//  Created by Adam Boyher on 7/1/24.
//

import SwiftUI

struct EnchantedContainerView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            EnchantedTheme.background.ignoresSafeArea()
            content
        }
    }
}
