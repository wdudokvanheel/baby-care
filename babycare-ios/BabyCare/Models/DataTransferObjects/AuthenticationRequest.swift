public struct AuthenticationRequest: Encodable {
    public let email: String
    public let password: String
    public let deviceId: String
}
