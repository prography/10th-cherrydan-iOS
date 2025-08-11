protocol APIEndpoint {
    var tokenType: TokenType { get }
    var path: String { get }
    var method: HTTPMethod { get }
}
