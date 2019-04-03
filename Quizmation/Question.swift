//
//  Question.swift
//  Quizmation
//
//  Created by Ammar AlTahhan on 03/04/2019.
//  Copyright © 2019 Ammar AlTahhan. All rights reserved.
//

import Foundation

struct Question: Codable {
    var answer: Int
    var title: String
    var options: [String]
}
