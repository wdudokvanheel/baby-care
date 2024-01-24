import Foundation
import os
import SwiftData
import SwiftUI

public class BabyService: ObservableObject {
    private let container: ModelContainer
    private let apiService: ApiService

    init(_ container: ModelContainer, _ apiService: ApiService) {
        self.container = container
        self.apiService = apiService
    }

    public func getAllBabies() async -> [Baby] {
        await MainActor.run {
            var descriptor = FetchDescriptor<Baby>()

            do {
                let result = try container.mainContext.fetch(descriptor)
                return result
            } catch {
                print("Erorr \(error)")
            }
            return []
        }
    }

    public func insertOrUpdateBaby(_ dto: BabyDto) async {
        let baby = await getByRemoteId(dto.id)

        if let baby = baby {
            await MainActor.run {
                print("Updating baby #\(dto.id)")
                baby.update(source: dto)
            }
        } else {
            print("Adding baby #\(dto.id)")
            let newAction = Baby(from: dto)
            await save(newAction)
        }
    }

    public func getByRemoteId(_ id: Int) async -> Baby? {
        let id = Int64(id)

        return await MainActor.run {
            var descriptor = FetchDescriptor<Baby>(predicate: #Predicate {
                $0.remoteId == id
            })

            descriptor.fetchLimit = 1

            do {
                let result = try container.mainContext.fetch(descriptor)
                if result.count > 0 {
                    return result[0]
                }
            } catch {
                print("Erorr \(error)")
            }
            return nil
        }
    }

    public func save(_ baby: Baby) async {
        await MainActor.run {
            self.container.mainContext.insert(baby)
        }
    }
}
