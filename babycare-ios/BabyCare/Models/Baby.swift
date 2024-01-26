//
//  Baby.swift
//  BabyCare
//
//  Created by Wesley Dudok van Heel on 25/01/2024.
//
//

import Foundation
import SwiftData


@Model public class Baby {
    public var id: UUID?
    var name: String?
    var birthDate: Date?
    var remoteId: Int64? = 0
    var lastSync: Int64? = 0
    public init() {

    }
    
}
