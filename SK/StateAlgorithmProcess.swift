//
//  StateAlgorithmProcess.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//
import SwiftUI
import Foundation

final class StateAlgorithmProcess: ObservableObject {
	
	// Количество тактов процессора
	@Published
	var count: Int = 0
	
	// Основная память
	@Published
	var memory: [Int] = Array(repeating: 0, count: 16)
	
	// Кэши процессора
	@Published
	var cacheM: [[Cache]] = Array(repeating: Array(repeating: Cache(), count: 4), count: 4)
	
	// Address
	@Published
	var isAddressProcess: Bool = false
	
	// data
	@Published
	var isDataProcess: Bool = false
	
	// Status
	@Published
	var isStatusProcess: Bool = false
	
	public func read(n_cpu: Int, address: Int) {
		let tmp = checkESm_M(nCpu: n_cpu, address: address)
		
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].blockM?.address == address {
				if cacheM[n_cpu][i].status == .Sm || cacheM[n_cpu][i].status == .M {
					increaseCount()
					flush(new_block: cacheM[n_cpu][i].blockM)
				}
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
		
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].blockM?.address == -1 {
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
		
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].priority == 1 {
				if cacheM[n_cpu][i].status == .Sm || cacheM[n_cpu][i].status == .M {
					increaseCount()
					flush(new_block: cacheM[n_cpu][i].blockM)
				}
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
		
	}
	
	public func write(n_cpu: Int, address: Int) {
		guard let tmp = writeCheck(nCpu: n_cpu, address: address) else {
			return
		}
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].blockM?.address == address {
				if cacheM[n_cpu][i].status == .Sm || cacheM[n_cpu][i].status == .M {
					increaseCount()
					flush(new_block: cacheM[n_cpu][i].blockM)
				}
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
		
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].blockM?.address == -1 {
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
		
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].priority == 1 {
				if cacheM[n_cpu][i].status == .Sm || cacheM[n_cpu][i].status == .M {
					increaseCount()
					flush(new_block: cacheM[n_cpu][i].blockM)
				}
				cacheM[n_cpu][i] = tmp
				resetPriority(n_cpu: n_cpu, address: address)
				return
			}
		}
	}
	
	public func resetState() {
		count = 0
		memory = Array(repeating: 0, count: 16)
		cacheM = Array(repeating: Array(repeating: Cache(), count: 4), count: 4)
	}
	
}

private extension StateAlgorithmProcess {
	
	func writeCheck(nCpu: Int, address: Int) -> Cache? {
		var result: Cache? = nil
		if haveInThis(nCpu: nCpu, address: address) && !haveInOther(nCpu: nCpu, address: address) {
			for item in cacheM[nCpu] {
				if item.blockM?.address == address {
					result = item
					result?.blockM?.data += 1
					result?.status = .M
					result?.priority = 1
					return result
				}
			}
		} else if haveInThis(nCpu: nCpu, address: address) && haveInOther(nCpu: nCpu, address: address) {
			for item in cacheM[nCpu] {
				if item.blockM?.address == address {
					result = item
					result?.status = .Sm
					result?.priority = 1
					result?.blockM?.data += 1
					
				}
			}
			activateAddressProcess()
			activateDataProcess()
			activateStatusProcess()
			increaseCount()
			for i in 0..<3 where i != nCpu {
				for j in 0...cacheM[i].count - 1 {
					if cacheM[i][j].blockM?.address == address {
						cacheM[i][j].status = .Sc
						cacheM[i][j].blockM?.data += 1
						cacheM[i][j].priority = 1
					}
				}
			}
			return result
		} else if !haveInThis(nCpu: nCpu, address: address) && !haveInOther(nCpu: nCpu, address: address) {
			activateAddressProcess()
			activateDataProcess()
			increaseCount()
			return Cache(blockM: Block(address: address, data: memory[address] + 1), status: .M, priority: 1)
		} else if !haveInThis(nCpu: nCpu, address: address) && haveInOther(nCpu: nCpu, address: address) {
			activateAddressProcess()
			activateDataProcess()
			activateStatusProcess()
			increaseCount()
			for i in 0..<3 where i != nCpu {
				for j in 0...cacheM[i].count - 1 {
					if cacheM[i][j].blockM?.address == address {
						cacheM[i][j].status = .Sc
						cacheM[i][j].blockM?.data += 1
						cacheM[i][j].priority = 1
						result = cacheM[i][j]
					}
				}
			}
			return Cache(blockM: Block(address: address, data: result?.blockM?.data ?? 0), status: .Sm, priority: 1)
		}
		return nil
	}
	
}

private extension StateAlgorithmProcess {
	
	func increaseCount() {
		count += 1
	}
	
	func checkESm_M(nCpu: Int, address: Int) -> Cache {
		for i in 0...cacheM[nCpu].count - 1 {
			if cacheM[nCpu][i].blockM?.address == address {
				resetPriority(n_cpu: nCpu, address: address)
				return Cache(blockM: cacheM[nCpu][i].blockM, status: cacheM[nCpu][i].status, priority: 1)
			}
		}
		return checkOther(nCpu: nCpu, address: address)
	}
	
	func checkOther(nCpu: Int, address: Int) -> Cache {
		for i in 0..<4 where i != nCpu {
			for j in 0...cacheM[i].count - 1 {
				if cacheM[i][j].blockM?.address == address {
					increaseCount()
					activateAddressProcess()
					activateDataProcess()
					activateStatusProcess()
					flush(new_block: cacheM[i][j].blockM)
					switch cacheM[i][j].status {
					case .M:
						cacheM[i][j].status = .Sm
					case .E:
						cacheM[i][j].status = .Sc
					default:
						break
					}
					return Cache(blockM: cacheM[i][j].blockM, status: .Sc, priority: 1)
				}
			}
		}
		return checkMemory(nCpu: nCpu, address: address)
	}
	
	func checkMemory(nCpu: Int, address: Int) -> Cache {
		activateAddressProcess()
		activateDataProcess()
		increaseCount()
		return Cache(blockM: Block(address: address, data: memory[address]), status: .E, priority: 1)
	}
	
	func flush(new_block: Block?) {
		guard let address = new_block?.address, let data = new_block?.data else {
			return
		}
		memory[address] = data
	}
	
	func resetPriority(n_cpu: Int, address: Int) {
		for i in 0...cacheM[n_cpu].count - 1 {
			if cacheM[n_cpu][i].blockM?.address != address {
				cacheM[n_cpu][i].priority = 0
			}
		}
	}
	
}

private extension StateAlgorithmProcess {
	
	func activateAddressProcess() {
		isAddressProcess = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.isAddressProcess = false
		}
	}
	
	func activateDataProcess() {
		isDataProcess = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.isDataProcess = false
		}
 	}
	
	func activateStatusProcess() {
		isStatusProcess = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.isStatusProcess = false
		}
	}
	
}

private extension StateAlgorithmProcess {
	
	func haveInThis(nCpu: Int, address: Int) -> Bool {
		for block in cacheM[nCpu] {
			if block.blockM?.address == address {
				return true
			}
		}
		return false
	}
	
	func haveInOther(nCpu: Int, address: Int) -> Bool {
		for i in 0..<3 where i != nCpu {
			for block in cacheM[i] {
				if block.blockM?.address == address {
					return true
				}
			}
		}
		return false
	}
	
}
