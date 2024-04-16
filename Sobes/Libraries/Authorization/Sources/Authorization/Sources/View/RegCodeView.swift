//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 17.04.2024.
//

import SwiftUI

struct RegCodeView: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            back
            Text("Код")
                .font(Font.custom("CoFoSans-Bold", size: 23))
                .foregroundColor(.black)
                .padding(.top, 20)
            Text("На вашу электронную почту было отправлено письмо с кодом подтверждения")
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .foregroundColor(.black)
                .padding(.top, 16)
            //TODO: место для техтфилда
            Spacer()
            button
            
        }
        .padding(.top, 66)
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    //TODO: перенести в компоненты
    var button: some View {
        Button (action: {}) {
            Text("Дальше")
                .bold()
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
            
        }.background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("accent", bundle: .module))
        }
        .padding(.horizontal, 20)
    }
    
    //TODO: перенести в компоненты
    var back: some View {
        Button(action: {}) {
            Image(systemName: "chevron.backward")
                .frame(width: 28, height: 28)
                .foregroundColor(.black)
                .padding(15)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("light", bundle: .module))
        }
    }
}

#Preview {
    RegCodeView()
}
