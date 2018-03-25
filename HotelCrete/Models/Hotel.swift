//
//  Hotel.swift
//  HotelCrete
//
//  Created by John Nik on 23/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

struct Response: Codable {
    let res: String
}

struct GeneralRequest: Codable {
    let id: Int
}

enum Status: String {
    case success = "success"
    case fail = "fail"
}

class Hotel {
    
    struct HotelId: Codable {
        let id: Int
    }
    
    //contact us
    
    enum ResultContact {
        case success(ResponseContact)
        case failure(Error)
    }
    
    struct ResponseContact: Codable {
        let status: Bool?
        let msg: String?
        let result: [Contact]?
    }
    
    struct RequestContact: Codable {
        let Contact: HotelId
    }
    
    struct Contact: Codable {
        let Contact: ContactDetail?
    }
    
    struct ContactDetail: Codable {
        let id: String?
        let hotelid: String?
        let info: String?
        let created_date: String?
        
        let info_french: String?
        let info_german: String?
        let info_italian: String?
        let info_russian: String?
    }
    
    //questionnaires answer
    
    enum ResultRating {
        case success(ResponseRating)
        case failure(Error)
    }
    
    struct ResponseRating: Codable {
        let status: Bool?
        let msg: String?
    }
    
    struct QuestionnairesAnswer: Codable {
        let QuestionnairesAnswer: OverallRating
    }
    
    struct OverallRating: Codable {
        let userId: String?
        let result: [QuestionnaireAnswer]
        let rating: Int?
        let comments: String?
    }
    
    struct QuestionnaireAnswer: Codable {
        let id: String
        let value: String?
    }
    
    //questionnaires
    
    enum ResultQuestionnaire {
        case success(ReponseQuestionnaire)
        case failure(Error)
    }
    
    struct RequestQuestionnaire: Codable {
        let Questionnaire: HotelId
    }
    
    struct ReponseQuestionnaire: Codable {
        let status: Bool?
        let msg: String?
        let result: [Questionnaire]?
    }
    
    struct Questionnaire: Codable {
        
        let category: String?
        let category_greek: String?
        var value: [Question]
    }
    
    struct Question: Codable {
        let id: String?
        let hotelid: String?
        let category: String?
        let category_greek: String?
        let question: String?
        let question_greek: String?
        let created_date: String?
        var answer: String?
        
        var category_french: String?
        var question_french: String?
        var category_german: String?
        var question_german: String?
        var category_italian: String?
        var question_italian: String?
        var category_russian: String?
        var question_russian: String?
    }
    
    
    //get hotel social media info
    
    struct SocialRequest: Codable {
        let Social: HotelId
    }
    
    enum ResultHotelSocial {
        case success(HotelSocialReponse)
        case failure(Error)
    }
    
    struct HotelSocialReponse: Codable {
        let status: Bool?
        let msg: String?
        let result: [Social]?
    }
    
    struct Social: Codable {
        let Social: SocialInfo?
    }
    
    struct SocialInfo: Codable {
        let id: String?
        let hotleid: String?
        let title: String?
        let link: String?
        let created_date: String?
        
        let title_french: String?
        let title_german: String?
        let title_italian: String?
        let title_russian: String?
    }
    
    //get hotel accommodation info
    
    struct AccommodationRequest: Codable {
        let Accommodation: HotelId
    }
    
    enum ResultHotelAccommodation {
        case success(HotelAccommodationReponse)
        case failure(Error)
    }
    
    struct HotelAccommodationReponse: Codable {
        let status: Bool?
        let msg: String?
        let result: [Accommodation]?
    }
    
    struct Accommodation: Codable {
        let Accommodation: AccommodationInfo?
    }
    
    struct AccommodationInfo: Codable {
        let id: String?
        let hotleid: String?
        let title: String?
        let title_greek: String?
        let description: String?
        let description_greek: String?
        let created_date: String?
        let image: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
    }
    
    //get hotel facilitie list
    
    struct FacilitieRequest: Codable {
        let Facilitie: TempFacilitie
    }
    
    struct TempFacilitie: Codable {
        let id: Int
        let category: String?
    }
    
    enum ResultHotelFacilitie {
        case success(HotelFacilitieReponse)
        case failure(Error)
    }
    
    struct HotelFacilitieReponse: Codable {
        let status: Bool?
        let msg: String?
        let result: [Facilitie]?
    }
    
    struct Facilitie: Codable {
        let Facilitie: FacilitieInfo?
    }
    
    struct FacilitieInfo: Codable {
        let id: String?
        let hotleid: String?
        let category: String?
        let category_greek: String?
        let title: String?
        let title_greek: String?
        let description: String?
        let description_greek: String?
        let created_date: String?
        let image: String?
        
        let category_french: String?
        let title_french: String?
        let description_french: String?
        let category_german: String?
        let title_german: String?
        let description_german: String?
        let category_italian: String?
        let title_italian: String?
        let description_italian: String?
        let category_russian: String?
        let title_russian: String?
        let description_russian: String?
    }
    
    
    //get hotel service info
    
    struct ServiceRequest: Codable {
        let Service: HotelId
    }
    
    enum ResultHotelService {
        case success(HotelServiceReponse)
        case failure(Error)
    }
    
    struct HotelServiceReponse: Codable {
        let status: Bool?
        let msg: String?
        let result: [Service]?
    }
    
    struct Service: Codable {
        let Service: ServiceInfo?
    }
    
    struct ServiceInfo: Codable {
        let id: String?
        let hotleid: String?
        let title: String?
        let title_greek: String?
        let description: String?
        let description_greek: String?
        let created_date: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
    }
    
    //get hotel about info
    
    struct HotelAboutReponse: Codable {
        let status: Bool?
        let msg: String?
        let result: [HotelAbout]?
    }
    
    struct HotelAbout: Codable {
        let addhotels: HotelInfo?
        let About: BackgroundInfo?
    }
    
    enum ResultHotelAbout {
        case success(HotelAboutReponse)
        case failure(Error)
    }
    
    //get hotel info
    struct HotelInfoRequest: Codable {
        let code: Int
    }
    
    struct HotelInfo: Codable {
        let id: String?
        let code: String?
        let hotelname: String?
        let groupname: String?
        let description: String?
        let created_date: String?
        let hotelname_greek: String?
        let groupname_greek: String?
        let description_greek: String?
        let service_image: String?
        let facilitie_image: String?
        let accommodation_image: String?
        
        let hotelname_french: String?
        let groupname_french: String?
        let description_french: String?
        let hotelname_german: String?
        let groupname_german: String?
        let description_german: String?
        let hotelname_italian: String?
        let groupname_italian: String?
        let description_italian: String?
        let hotelname_russian: String?
        let groupname_russian: String?
        let description_russian: String?
        
        let latitude: String?
        let longitude: String?
    }
    
    struct AddHotel: Codable {
        let AddHotel: HotelInfo?
    }
    
    struct HotelInfoResponse: Codable {
        let status: Bool?
        let msg: String?
        let result: AddHotel?
    }
    
    enum ResultHotelInfo {
        case success(HotelInfoResponse)
        case failure(Error)
    }
    
    //get hotel background
    struct BackgroundInfo: Codable {
        let id: String?
        let hotelId: String?
        let image: String?
        let created: String?
        
        enum CodingKeys: String, CodingKey {
            case hotelId = "hotelid"
            case id, image, created
        }
    }
    
    struct Background: Codable {
        let Background: BackgroundInfo?
    }
    
    struct HotelBackgroundResponse: Codable {
        let status: Bool?
        let msg: String?
        let result: Background
    }
    
    enum ResultHotelBackground {
        case success(HotelBackgroundResponse)
        case failure(Error)
    }
    
    // register user
    struct RegisterUser: Codable {
        let surname: String
        let name: String
        let code: Int
        let email: String?
        let checkIn: String?
        let checkOut: String?
        let token: String
    }
    
    struct RegisterUserResponse: Codable {
        let id: String?
        let status: Bool?
        let msg: String?
    }
    
    enum ResultRegisterUser {
        case success(RegisterUserResponse)
        case failure(Error)
    }
    
    //check hotel code
    enum CheckHotelNumber {
        case success(Response)
        case failure(Error)
    }
    
    struct HotelNumber: Codable {
        let hotelNumber: Int
        
        static func archive(_ hotelNumber: HotelNumber) -> Data {
            var temp = hotelNumber
            return Data(bytes: &temp, count: MemoryLayout<HotelNumber>.stride)
        }
    }
    
    
}
