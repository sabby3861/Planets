//
//  JPPayload.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 03/05/2021.
//

import Foundation
protocol PayLoadFormat {
    func formatGetPayload(url: JPHTTPUrl, type: JPHTTPPayloadType) -> JPHTTPPayloadProtocol
}
extension PayLoadFormat{
    func formatGetPayload(url: JPHTTPUrl, type: JPHTTPPayloadType) -> JPHTTPPayloadProtocol{
        var payload = GJHTTPPayload(url: url,payloadType: type)
        payload.headers = Dictionary<String, String>()
        payload.addHeader(name: JPHTTPHeaderType.contentType.rawValue, value: JPHTTPMimeType.applicationJSON.rawValue)
        return payload
    }
}

protocol JPHTTPPayloadProtocol {
    var type: JPHTTPPayloadType? { get }
    var headers: Dictionary<String, String>? { get set }
    var url: String {get}
}
/// Payload
struct GJHTTPPayload: JPHTTPPayloadProtocol {
    var type: JPHTTPPayloadType?
    var headers: Dictionary<String, String>?
    var url: String
    
    fileprivate init(url: JPHTTPUrl, payloadType: JPHTTPPayloadType) {
        self.type = payloadType
        self.url = url.rawValue
    }
    fileprivate mutating func addHeader(name: String, value: String) {
        headers?[name] = value
    }
}

enum JPHTTPMimeType: String {
    case applicationJSON = "application/json; charset=utf-8"
}
enum JPHTTPHeaderType: String{
    case contentType    = "Content-Type"
}

enum JPHTTPMethod: String {
    case get
    case put
}

enum JPHTTPPayloadType{
    case requestMethodGET
    case requestMethodPUT
    func httpMethod() -> String {
        switch self{
        case .requestMethodGET: return JPHTTPMethod.get.rawValue
        case .requestMethodPUT: return JPHTTPMethod.put.rawValue
        }
    }
}

enum JPHTTPUrl: String {
    case planetsUrl = "https://swapi.dev/api/planets/"
}
