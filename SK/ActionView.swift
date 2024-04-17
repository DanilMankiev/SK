//
//  ActionView.swift
//  SK
//
//  Created by Илья Горяев on 16.04.2024.
//

import SwiftUI

struct ActionView: View {
	
	@Binding
	var isAddressLight: Bool
	@Binding
	var isDataLight: Bool
	@Binding
	var isStatusLight: Bool
	
    var body: some View {
		HStack {
			ColorView(color: .blue, title: "Address", isLight: $isAddressLight)
			ColorView(color: .red, title: "Data", isLight: $isDataLight)
			ColorView(color: .yellow, title: "Status", isLight: $isStatusLight)
		}
    }
}

struct ColorView: View {
	
	var color: Color
	var title: String
	@Binding
	var isLight: Bool
	
	var body: some View {
		VStack {
			Text(title)
			ZStack {
				Circle()
					.foregroundStyle(color)
					.opacity(isLight ? 1 : 0)
				Circle()
					.stroke(lineWidth: 2)
			}
			.padding()
		}
	}
}
