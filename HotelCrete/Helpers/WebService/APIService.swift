//
//  APIService.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation
import SVProgressHUD

class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    let webService = WebService()
    
    func handleGetPinData(_ request: HotelMap.RequestGuide, completion: @escaping (HotelMap.ResultPinData) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getPinData, model: request) { (result: WebService.Result<HotelMap.ResponsePinData>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetMapMenuList(completion: @escaping (HotelMap.ResultGuideCrete) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getMenuMapList, data: nil) { (result: WebService.Result<HotelMap.ResponseGuideCrete>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetUsefulNumbers(completion: @escaping (UsefulNumbers.ResultUsefulNumbers) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getUsefulNumbers, data: nil) { (result: WebService.Result<UsefulNumbers.ResponseUsefulNumbers>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetUsefulInfo(completion: @escaping (UsefulInfo.ResultUsefulInfo) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getUsefulInfo, data: nil) { (result: WebService.Result<UsefulInfo.ResponseUsefulInfo>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetGreekWords(completion: @escaping (GreekWord.ResultGreekWord) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getGreekWords, data: nil) { (result: WebService.Result<GreekWord.ResponseGreekWord>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleWeatherAPI(completion: @escaping (Weather.ResultWeather) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.openWeatherMapAPI, data: nil) { (result: WebService.Result<Weather.ResponseWeather>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetMessages(_ request: Message.RequestChat, completion: @escaping (Message.ResultChat) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getMessages, model: request) { (result: WebService.Result<Message.ResponseChat>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetGuideCreteBeacheRegion(completion: @escaping (Crete.ResultBeachRegion) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getGuideCreteBeachArea, data: nil) { (result: WebService.Result<Crete.ResponseBeachRegion>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetGuideCrete(completion: @escaping (Crete.ResultGuideCrete) -> ()) {
        
        webService.urlSession(method: nil, urlString: ServerUrls.getGuideCrete, data: nil) { (result: WebService.Result<Crete.ResponseGuideCrete>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetAboutCrete(completion: @escaping (Crete.ResultAboutCrete) -> ()) {
        
        
        webService.urlSession(method: nil, urlString: ServerUrls.getAboutCrete, data: nil) { (result: WebService.Result<Crete.ResponseAboutCrete>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetGuideCreteVillages(_ request: Crete.RequestGuideVillage, completion: @escaping (Crete.ResultGuideVillage) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getGuideCreteRegions, model: request) { (result: WebService.Result<Crete.ResponseGuideVillage>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetCreteExtra(_ request: Crete.HotelId, completion: @escaping (Crete.ResultCreteExtra) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getCreteExtras, model: request) { (result: WebService.Result<Crete.ResponseCreteExtra>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetCreteExtraDetail(_ request: Crete.RequestCreteExtraDetail, completion: @escaping (Crete.ResultCreteExtraDetail) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getCreteExtrasDetail, model: request) { (result: WebService.Result<Crete.ResponseCreteExtraDetail>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleSubmitQuestinnaire(_ request: Hotel.QuestionnairesAnswer, completion: @escaping (Hotel.ResultRating) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.submitHotelQuestionnaire, model: request) { (result: WebService.Result<Hotel.ResponseRating>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetQuestinnaire(_ request: Hotel.RequestQuestionnaire, completion: @escaping (Hotel.ResultQuestionnaire) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelQuestionnaire, model: request) { (result: WebService.Result<Hotel.ReponseQuestionnaire>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetContact(_ request: Hotel.RequestContact, completion: @escaping (Hotel.ResultContact) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getContacts, model: request) { (result: WebService.Result<Hotel.ResponseContact>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelSocial(_ request: Hotel.SocialRequest, completion: @escaping (Hotel.ResultHotelSocial) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelSocialMedia, model: request) { (result: WebService.Result<Hotel.HotelSocialReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelAccommodation(_ request: Hotel.AccommodationRequest, completion: @escaping (Hotel.ResultHotelAccommodation) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelAccommodation, model: request) { (result: WebService.Result<Hotel.HotelAccommodationReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelFacilitie(_ request: Hotel.FacilitieRequest, completion: @escaping (Hotel.ResultHotelFacilitie) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelFacilitie, model: request) { (result: WebService.Result<Hotel.HotelFacilitieReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelFacilitieList(_ request: Hotel.FacilitieRequest, completion: @escaping (Hotel.ResultHotelFacilitie) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelFacilitieList, model: request) { (result: WebService.Result<Hotel.HotelFacilitieReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelService(_ request: Hotel.ServiceRequest, completion: @escaping (Hotel.ResultHotelService) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelService, model: request) { (result: WebService.Result<Hotel.HotelServiceReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelAbout(_ request: Hotel.AddHotel, completion: @escaping (Hotel.ResultHotelAbout) -> ()) {
        
        webService.urlSession(urlString: ServerUrls.getHotelAbout, model: request) { (result: WebService.Result<Hotel.HotelAboutReponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleGetHotelInfo(_ request: Hotel.HotelInfoRequest, completion: @escaping (Hotel.ResultHotelInfo) -> ()) {
        
        guard let dictionary = request.dictionary else { return }
        
        webService.urlSessionUrlencoded(urlString: ServerUrls.getHotelInfo, dictionary: dictionary) { (result: WebService.Result<Hotel.HotelInfoResponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
    }
    
    func handleGetHotelBackground(_ generalRequest: GeneralRequest, completion: @escaping (Hotel.ResultHotelBackground) -> ()) {
        
        guard let dictionary = generalRequest.dictionary else { return }
        
        webService.urlSessionUrlencoded(urlString: ServerUrls.getHotelBackground, dictionary: dictionary) { (result: WebService.Result<Hotel.HotelBackgroundResponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func handleRegisterUser(_ registerUser: Hotel.RegisterUser, completion: @escaping (Hotel.ResultRegisterUser) -> ()) {
        
        guard let dictionary = registerUser.dictionary else { return }
        
        webService.urlSessionUrlencoded(urlString: ServerUrls.register, dictionary: dictionary) { (result: WebService.Result<Hotel.RegisterUserResponse>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
            
        }
    }
    
    func checkHotelCode(_ hotelNumber: Hotel.HotelNumber, completion: @escaping (Hotel.CheckHotelNumber) -> ()) {
        
        guard let dictionary = hotelNumber.dictionary else { return }
        
        webService.urlSessionUrlencoded(urlString: ServerUrls.checkHotelNumber, dictionary: dictionary) { (result: WebService.Result<Response>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
        
    }
    
    func checkHotelNumber(_ hotelNumber: Hotel.HotelNumber, completion: @escaping (Hotel.CheckHotelNumber) -> Void) {
        
        let data = Hotel.HotelNumber.archive(hotelNumber)
        
        webService.urlSession(method: "POST", urlString: ServerUrls.checkHotelNumber, data: data) { (result: WebService.Result<Response>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
            }
        }
        
    }
    
}
