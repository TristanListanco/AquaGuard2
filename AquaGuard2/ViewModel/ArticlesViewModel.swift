//
//  ArticlesViewModel.swift
//  AquaGuard2
//
//  Created by Tristan Listanco on 7/29/24.
//

import Foundation


class ArticleViewModel: ObservableObject {
    @Published var articles: [Article]

    init(articles: [Article]) {
        self.articles = articles
    }
}
