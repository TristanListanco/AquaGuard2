//
//  Articles.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Foundation

struct Article: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let content: String
}
