//
//  SwiftUIView.swift
//  Sobes
//
//  Created by Алиса Вышегородцева on 16.04.2024.
//  Copyright © 2024 FCS. All rights reserved.
//

import SwiftUI

struct EntryPointView: View {
    var body: some View {
        VStack (spacing: 30){
            Spacer()
            Text("Готовься продуктивно")
                .font(Font.custom("CoFoSans-Bold", size: 35))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            button
            
            Text("уже есть аккаунт? ")
                .font(Font.custom("CoFoSans-Regular", size: 13))
                .foregroundColor(Color("grey",bundle: .main))
            +
            Text("Войти")
                .bold()
                .font(Font.custom("CoFoSans-Bold", size: 13))
                .foregroundColor(Color("accent", bundle: .main))
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 89)
    }
    
    //TODO: перенести в компоненты

    var button: some View {
        Button (action: {}) {
            Text("Регистрация")
                .bold()
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
            
        }.background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("accent", bundle: .main))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    EntryPointView()
}
