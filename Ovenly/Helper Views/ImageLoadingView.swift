//
//  ImageLoadingView.swift
//  Ovenly
//
//  Created by Jessica Parsons on 2/10/25.
//

import SwiftUI

struct ImageLoadingView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            ProgressView()
        }
    }
}

#Preview {
    ImageLoadingView()
}
