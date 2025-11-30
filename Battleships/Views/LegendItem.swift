//
//  LegendItem.swift
//  Battleships
//
//  Created by MAT on 30/11/2025.
//

import SwiftUI

struct LegendItem: View {
    let color: Color
    let label: String
    private let textColor = Color(red: 46/255, green: 103/255, blue: 106/255)
    
    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(width: 12, height: 12)
                .border(textColor, width: 0.5)
            Text(label)
                .font(.caption2)
                .foregroundColor(textColor)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        LegendItem(color: Color(red: 54/255, green: 47/255, blue: 22/255), label: "Ship")
        LegendItem(color: Color(red: 180/255, green: 90/255, blue: 90/255), label: "Hit")
        LegendItem(color: Color(red: 108/255, green: 140/255, blue: 106/255), label: "Miss")
        LegendItem(color: Color(red: 200/255, green: 200/255, blue: 200/255), label: "Empty")
    }
    .padding()
    .background(Color(red: 213/255, green: 226/255, blue: 217/255))
}
