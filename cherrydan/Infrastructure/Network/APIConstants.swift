//
//  APIConstants.swift
//  cherrydan
//
//  Created by Neoself on 7/3/25.
//


struct APIConstants {
    static let isServerDevelopment = true
    static let isUserDevelopment = true
    static let baseUrl = isServerDevelopment ? "https://cherrydan.com/api" : "http://43.201.140.227:8080/api"
}