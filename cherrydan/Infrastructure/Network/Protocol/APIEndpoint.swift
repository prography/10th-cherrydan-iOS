//
//  APIEndpoint.swift
//  cherrydan
//
//  Created by Neoself on 7/8/25.
//


protocol APIEndpoint {
    var tokenType: TokenType { get }
    var path: String { get }
    var method: HTTPMethod { get }
}