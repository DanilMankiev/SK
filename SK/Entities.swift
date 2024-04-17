//
//  Entities.swift
//  SK
//
//  Created by Илья Горяев on 14.04.2024.
//

import Foundation

struct Block: Hashable {
	var address: Int
	var data: Int
	
	init(address: Int = -1, data: Int = 0) {
		self.address = address
		self.data = data
	}
}

struct Cache: Identifiable, Hashable {
	static func == (lhs: Cache, rhs: Cache) -> Bool {
		lhs.blockM == rhs.blockM && lhs.priority == rhs.priority && lhs.status == rhs.status
	}
	
	var id = UUID().uuidString
	var blockM: Block?
	var status: CacheStatus?
	var priority: Int?
	
	init(blockM: Block? = Block(), status: CacheStatus? = .E, priority: Int? = 0) {
		self.blockM = blockM
		self.status = status
		self.priority = priority
	}

}

enum CacheStatus: String {
	case E
	case Sc
	case Sm
	case M
}

enum Mode {
	case read
	case write
}
