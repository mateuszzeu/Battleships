//
//  LegendView.swift
//  Battleships
//
//  Created by MAT on 30/11/2025.
//

import SwiftUI

struct LegendView: View {
    var body: some View {
        HStack(spacing: 16) {
            LegendItem(color: Color(red: 54/255, green: 47/255, blue: 22/255), label: "Statek")
            LegendItem(color: Color(red: 180/255, green: 90/255, blue: 90/255), label: "Trafiony")
            LegendItem(color: Color(red: 108/255, green: 140/255, blue: 106/255), label: "Pudło")
            LegendItem(color: Color(red: 200/255, green: 200/255, blue: 200/255), label: "Puste")
        }
        .padding(.top, 8)
    }
}

#Preview {
    LegendView()
        .padding()
        .background(Color(red: 213/255, green: 226/255, blue: 217/255))
}
