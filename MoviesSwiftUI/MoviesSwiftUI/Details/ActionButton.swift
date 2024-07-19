//
//  ActionButton.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 19.07.2024.
//

import Foundation
import SwiftUI

struct ActionButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .foregroundColor(.gray)
        }
    }
}
