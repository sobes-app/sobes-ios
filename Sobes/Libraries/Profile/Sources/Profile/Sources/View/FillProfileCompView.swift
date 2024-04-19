//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct FillProfileCompView: View {
    @State private var present: Bool = false
    @State private var isOn: Bool = false
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                VStack {
                    Text("Последний рывок!")
                        .font(Font.custom("CoFoSans-Regular", size: 13))
                        .foregroundColor(.black)
                    Text("В каких компаниях ты хочешь работать?")
                        .font(Font.custom("CoFoSans-Bold", size: 23))
                        .foregroundColor(.black)
                }
                specListView
            }
            .padding(.top, 20)
            Spacer()
            VStack(spacing: 16) {
                ProgressView(value: 1)
                    .padding(.horizontal, 20)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                button
            }
            
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }

    
    var specListView: some View {
        VStack (alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Тинькофф")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Сбер")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Яндекс")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Другое")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
        }
    }
    
    var back: some View {
        BackButton()
    }
    
    var button: some View {
        MainButton(action: {present = true}, label: "Закончили!")
            .navigationDestination(isPresented: $present) {

            }
    }
}

#Preview {
    FillProfileCompView()
}
