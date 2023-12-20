//
//  home.swift
//  NC2
//
//  Created by Lujain Abdullah Halabi Almeri on 06/06/1445 AH.
//

import SwiftUI

struct home: View {
    var body: some View {
        ZStack{
            Color("lColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                CalendarView()
                mealsDetails()
                Image("bg").resizable().frame(width: 500, height: 500)
                    .padding(.top, -20)
            }.padding(.top, 150)
        }
    }
}

#Preview {
    home()
}
