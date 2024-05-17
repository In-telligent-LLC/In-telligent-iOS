//
//  API.swift
//  Intelligent
//
//  Created by Kurt on 9/27/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

/* https://in-telligent.restlet.io/ */

public class API {
    
    static public let shared: API = API()
    
    public typealias APIResponseSuccessHandler = (_ json: JSON) -> Void
    public typealias APIResponseSuccessVoidHandler = () -> Void
    public typealias APIResponseFailureHandler = (_ error: Error?) -> Void
    
    let apiBaseURL: URL = {
        return URL(string: "https://api.in-telligent.com/api")!
    }()

    private (set)var activeRequests = 0 {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.activeRequests > 0
            }
        }
    }
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = INRequestAdapter()
        return sessionManager
    }()
}

class INRequestAdapter: RequestAdapter, RequestRetrier {
    
    func isAuthenticatedURL(_ url: URL?) -> Bool {
        guard let url = url else { return false }
        
        let urlString = url.absoluteString
        return !(urlString.contains("/subscribers/checkEmail") || urlString.contains("/auth/"))
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("ios", forHTTPHeaderField: "X-Device-Type")
        urlRequest.setValue(UIApplication.shared.build, forHTTPHeaderField: "X-App-Version")
        
        let isAuthenticated = isAuthenticatedURL(urlRequest.url)
        if let token = INSessionManager.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if isAuthenticated && urlRequest.allHTTPHeaderFields?["Authorization"] == nil {
            INSubscriberManager.logOut()
            throw INError(message: nil)
        }
        
        return urlRequest
    }
    
    func should(_ manager:      Alamofire.SessionManager,
                retry request:  Alamofire.Request,
                with error:     Error,
                completion:     @escaping Alamofire.RequestRetryCompletion) {
        Logging.info(error)
        let nsError = error as NSError
        Logging.info("\(nsError.domain) \(nsError.code) \(nsError.description)")
        
        guard request.retryCount < 5 else {
            Logging.info("Already retried 5 times")
            return completion(false, 0)
        }
        
        guard nsError.domain == NSURLErrorDomain else {
            Logging.info("Cancelling retry. Domain")
            return completion(false, 0)
        }
        
        switch nsError.code {
        case NSURLErrorCannotFindHost,
             NSURLErrorDNSLookupFailed,
             NSURLErrorCannotConnectToHost,
             NSURLErrorNotConnectedToInternet,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorTimedOut,
             53: // The operation couldn’t be completed. Software caused connection abort (https://github.com/AFNetworking/AFNetworking/issues/4279)

            return completion(true, TimeInterval(request.retryCount))
        default:
            return completion(false, 0)
        }
    }
}

extension API {
    
    @discardableResult
    func get(endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, success: APIResponseSuccessHandler?, failure: APIResponseFailureHandler?) -> DataRequest {
        let url = apiBaseURL.appendingPathComponent(endpoint)
        return request(url: url, method: .get, parameters: parameters, headers: headers, encoding: URLEncoding.default, success: success, failure: failure)
    }
    
    @discardableResult
    func post(endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, success: APIResponseSuccessHandler?, failure: APIResponseFailureHandler?) -> DataRequest {
        let url = apiBaseURL.appendingPathComponent(endpoint)
        return request(url: url, method: .post, parameters: parameters, headers: headers, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
}

extension API {
    
    private func request(url: URL, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders? = nil, encoding: ParameterEncoding, success: APIResponseSuccessHandler?, failure: APIResponseFailureHandler?) -> DataRequest {
        
        activeRequests += 1
        let request = sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            self.activeRequests -= 1
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                Logging.info(json)
                success?(json)
            case .failure(let error):
                Logging.info(url, error)
                failure?(error)
            }
        }
        
        Logging.info(request)

        return request
    }
    
}
