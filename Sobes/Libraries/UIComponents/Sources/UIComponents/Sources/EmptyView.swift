//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 05.05.2024.
//

import SwiftUI

public struct EmptyDataView: View {
    let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Image("empty_view", bundle: .module)
            Text(text)
                .font(Fonts.small)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("grey", bundle: .module))
        }
        .frame(maxWidth: .infinity)
    }
}

