import Foundation

class UserPreferencesService {
    func save(_ value: String, forKey key: String) {
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

    func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
