//
//  AddressView.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import SwiftUI

struct AdressView: View {
	
	@Binding
	private var cache: [Int]
	
	init(cache: Binding<[Int]>) {
		self._cache = cache
	}
	
    var body: some View {
		VStack {
			HStack {
				Spacer()
				Text("Adress")
				Spacer()
				Text("Data")
				Spacer()
			}
			ForEach(cache.indices, id: \.self) { index in
				HStack {
					Spacer()
					Text("A\(index)")
					Spacer()
					Text("\($cache.wrappedValue[index])")
					Spacer()
				}
			}
		}
    }
		
}
