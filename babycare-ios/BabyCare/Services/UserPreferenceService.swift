import Foundation

class UserPreferencesService {
    func save(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func save(_ value: Bool, forKey key: String) {
        print("Setting \(key) to \(value ? "true" : "false")")
        UserDefaults.standard.set(value, forKey: key)
    }

    func get(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    func getInt(forKey key: String) -> Int? {
        if let stringValue = UserDefaults.standard.string(forKey: key) {
            return Int(stringValue)
        }
        return nil
    }

    func getBool(forKey key: String) -> Bool? {
        if UserDefaults.standard.object(forKey: key) != nil {
            return UserDefaults.standard.bool(forKey: key)
        }
        return nil
    }

    func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func isPanelVisible(_ baby: Baby, _ panel: BabyActionType) -> Bool {
        guard let id = baby.remoteId else {
            return true
        }
        return getBool(forKey: "baby.panel.\(id).\(panel.rawValue.lowercased()).visible") ?? true
    }
}
