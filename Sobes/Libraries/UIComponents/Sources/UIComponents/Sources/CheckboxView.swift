//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI

public struct CheckboxView: View {
    @Binding private var isOn: Bool
    private var onTap: (() -> Void)?
    
    public init(isOn: Binding<Bool>, onTap: (() -> Void)? = nil) {
        self._isOn = isOn
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            isOn.toggle()
            onTap?()
        }) {
            Circle()
                .stroke()
                .foregroundColor(.black)
                .frame(width: 25)
                .background {
                    if isOn {
                        Circle()
                            .foregroundColor(Color(.accent))
                            .frame(width: 17, height: 17)
                    } else {
                        
                    }
                }
        }
    }
}
