//
//  DevelopersViewModel.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Foundation

class DevelopersViewModel: ObservableObject {
    @Published var developers: [Developers] = [
        Developers(name: "Tristan Listanco", url: "https://developer1.com"),
        Developers(name: "Princess Myer Fajardo", url: "https://developer2.com"),
        // Add more developers as needed
    ]
}
