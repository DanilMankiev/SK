//
//  CacheView.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import SwiftUI

struct CacheView: View {
	
	@Binding
	private var cache: [Cache]
	private let title: String
	
	init(cache: Binding<[Cache]>, title: String) {
		self._cache = cache
		self.title = title
	}
	
    var body: some View {
		VStack {
			Text(title)
				.bold()
			ForEach($cache, id: \.self) { item in
				HStack {
					Text(item.status.wrappedValue?.rawValue ?? "")
					Spacer()
					Text("\(item.blockM.wrappedValue?.address ?? 0)")
					Spacer()
					Text("\(item.blockM.wrappedValue?.data ?? 0)")
					Spacer()
					Text("\(item.priority.wrappedValue ?? 0)")
					Spacer()
				}
			}
		}
    }
}
