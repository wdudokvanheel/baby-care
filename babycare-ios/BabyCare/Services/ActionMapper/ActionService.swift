import Foundation
import os
import SwiftData
import SwiftUI

public protocol ActionService {
    associatedtype ActionType: Action
    
    func start(_ baby: Baby) -> any Action
    func stop(_ action: any Action)
    func update(_ action: any Action)
    func delete(_ action: any Action)
    func onActionUpdate(_ action: any Action)
    func createQueryByDate(_ baby: Baby, _ date: Date)-> Query<ActionType, [ActionType]>
}
