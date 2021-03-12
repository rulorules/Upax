//
//  File.swift
//  UPAX
//
//  Created by Raúl Jiménez on 12/03/21.
//

import Foundation

// MARK: - GraphStruct
struct TopGraphStruct: Codable {
    let colors: [String]
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let total: Int
    let text: String
    let chartData: [ChartDatum]
}

// MARK: - ChartDatum
struct ChartDatum: Codable {
    let text: String
    let percetnage: Int
}
