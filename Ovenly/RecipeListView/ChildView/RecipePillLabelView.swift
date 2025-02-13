//
//  RecipePillLabel.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/9/25.
//

import SwiftUI

struct RecipePillLabelView: View {
    
    let label: String
    let isSelected: Bool
    
    var body: some View {
        
        ZStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(isSelected ? Color.blackDM : Color.primary)
                .padding(.horizontal, Constants.horizontalPill)
                .padding(.vertical, Constants.verticalPill)
                .background(Capsule()
                    .fill(isSelected ? Color.myYellow : Color.clear))
                .overlay(Capsule().stroke(isSelected ? Color.clear : Color.myRed, lineWidth: 1))
            
        }//:ZSTACK
    }
}

#Preview {
    RecipePillLabelView(label: "Cookies", isSelected: true)
}
