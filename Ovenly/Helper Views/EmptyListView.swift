//
//  EmptyListView.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import SwiftUI

struct EmptyListView: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                Text(text)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(Color(UIColor.systemGray))
            Spacer()
        }
    }
}

#Preview {
    EmptyListView(icon: "heart.slash", text: "No favorites found! This is a long message to simulate multiline text")
}
