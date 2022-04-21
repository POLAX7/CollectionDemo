//
//  HTTPManager.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol HTTPManagerProtocol {
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
    func getAssets(page: Int) -> Observable<Assets>
}

class HTTPManager: HTTPManagerProtocol {
    
    public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let data = Data("The Data from HTTPManager".utf8)
            completionBlock(.success(data))
        }
    }
    
    public func getAssets(page: Int) -> Observable<Assets> {
        return request(ApiRouter.getAssets(page: page))
    }
    
    private func request(_ urlConvertible: URLRequestConvertible) -> Observable<Assets> {
        return Observable<Assets>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable(of: Assets.self) { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}





struct Constants {
    
    static let baseUrl = "https://api.opensea.io/api/v1/"

    struct Parameters {
        static let format = "format"
        static let json = "json"
        static let owner = "owner"
        static let address = "0x19818f44faf5a217f619aff0fd487cb2a55cca65"
        static let offset = "offset"
        static let limit = "limit"
        static let limitNum = 20
        static let apikey = "5b294e9193d240e39eefc5e6e551ce83"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case XAPIKEY = "X-API-KEY"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}


enum ApiRouter: URLRequestConvertible {
    
    case getAssets(page: Int)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        urlRequest.setValue(Constants.Parameters.apikey, forHTTPHeaderField: Constants.HttpHeaderField.XAPIKEY.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getAssets:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getAssets:
            return "assets"
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getAssets(let page):
            let pageNum = page * 20
            return [Constants.Parameters.format : Constants.Parameters.json,
                    Constants.Parameters.owner  : Constants.Parameters.address,
                    Constants.Parameters.limit  : Constants.Parameters.limitNum,
                    Constants.Parameters.offset : pageNum
                    ]
        }
    }
}

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

