//
//  AllCacheView.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import SwiftUI

struct AllCacheView: View {
	
	@Binding
	private var cacheArray: [[Cache]]
	
	init(cacheArray: Binding<[[Cache]]>) {
		self._cacheArray = cacheArray
	}
	
    var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach($cacheArray, id: \.self) { item in
					CacheView(cache: item, title: "Cache")
					Spacer()
				}
			}
		}
    }
}
