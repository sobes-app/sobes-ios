//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 24.04.2024.
//

import SwiftUI

public struct IncorrectView: View {
    let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .font(Fonts.small)
            .foregroundColor(.red)        
    }
}

