//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI

public struct CheckboxView: View {
    @Binding private var isOn: Bool
    
    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    public var body: some View {
        isOn ? AnyView(onToggleListItem) : AnyView(offToggleListItem)
    }
    
    var offToggleListItem: some View {
        Circle()
            .stroke()
            .frame(width: 25)
            .onTapGesture {
                isOn.toggle()
            }
    }
    
    var onToggleListItem: some View {
        Circle()
            .stroke()
            .frame(width: 25)
            .background {
                Circle()
                    .foregroundColor(Color(.accent))
                    .frame(width: 17, height: 17)
            }
            .onTapGesture {
                isOn.toggle()
            }
    }
}
