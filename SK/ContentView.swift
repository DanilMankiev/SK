//
//  ContentView.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import SwiftUI

struct ContentView: View {
	
	@State
	private var showBottomSheet = false
	
	@StateObject
	private var proccessState = StateAlgorithmProcess()
	
    var body: some View {
        VStack {
			VStack {
				Button(action: {
					showBottomSheet = true
				}, label: {
					Text("Update")
						.font(.largeTitle)
						.bold()
				})
				AdressView(cache: $proccessState.memory)
				AllCacheView(cacheArray: $proccessState.cacheM)
					.padding()
				ActionView(isAddressLight: $proccessState.isAddressProcess, isDataLight: $proccessState.isDataProcess, isStatusLight: $proccessState.isStatusProcess)
				Text("\($proccessState.count.wrappedValue)")
				Spacer()
				Button(action: {
					proccessState.resetState()
				}, label: {
					Text("Reset")
						.font(.largeTitle)
						.foregroundStyle(.red)
						.bold()
				})
			}
			
		}
		.sheet(isPresented: $showBottomSheet, content: {
			ScrollView(.horizontal) {
				HStack {
					ForEach(0..<4) { indexCPU in
						CPUTableView(title: "CPU\(indexCPU)") { mode, index in
							switch mode {
							case .read:
								proccessState.read(n_cpu: indexCPU, address: index)
							case .write:
								proccessState.write(n_cpu: indexCPU, address: index)
							}
							showBottomSheet = false
						}
					}
				}
			}
		})
	}
}

#Preview {
    ContentView()
}
