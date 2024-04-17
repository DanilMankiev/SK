//
//  CPUTableView.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import SwiftUI

struct CPUTableView: View {
	
	@State
	private var indexArray = Array(repeating: 0, count: 16)
	
	private let title: String
	private let action: (_ mode: Mode, _ index: Int) -> ()
	
	init(title: String, action: @escaping (_ mode: Mode, _ index: Int) -> ()) {
		self.title = title
		self.action = action
	}
	
    var body: some View {
		VStack {
			Text(title)
				.bold()
			ForEach(indexArray.indices, id: \.self) { index in
				HStack {
					Spacer()
					Button(action: {
						action(.read, index)
					}, label: {
						Text("readA\(index)")
					})
					Spacer()
					Button(action: {
						action(.write, index)
					}, label: {
						Text("writeA\(index)")
					})
					Spacer()
				}
				.padding(8)
			}
		}
    }
}

#Preview {
	CPUTableView(title: "CPU1") {mode,index in 
		
	}
}
