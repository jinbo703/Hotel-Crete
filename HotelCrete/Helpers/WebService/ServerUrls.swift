//
//  ServerUrls.swift
//  Wenyeji
//
//  Created by PAC on 2/10/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

class ServerUrls {
    
    // weather api
    static let openWeatherMapAPI = "http://api.openweathermap.org/data/2.5/forecast/daily?q=heraklion&appid=7756a5add72128537d61c8fccb203817&units=metric"
    static let weatherIconUrl = "http://openweathermap.org/img/w/%@.png"
    
    
//    static let baseUrl = "http://192.168.2.113/hotelandcrete/api/"
    static let baseUrl = "http://hotelandcrete.com/api/"
    
    static let checkHotelNumber = ServerUrls.baseUrl + "users/checkhotelnumber"
    static let register = ServerUrls.baseUrl + "users/registration"
    
    static let getHotelBackground = ServerUrls.baseUrl + "Addhotels/hotelbackground"
    static let getHotelInfo = ServerUrls.baseUrl + "Addhotels/hotelinfo"
    static let getHotelAbout = ServerUrls.baseUrl + "Addhotels/abouthotel"
    static let getHotelService = ServerUrls.baseUrl + "Addhotels/service"
    static let getHotelFacilitieList = ServerUrls.baseUrl + "Addhotels/facilitielist"
    static let getHotelFacilitie = ServerUrls.baseUrl + "Addhotels/facilitie"
    static let getHotelAccommodation = ServerUrls.baseUrl + "Addhotels/accommodation"
    static let getHotelSocialMedia = ServerUrls.baseUrl + "Addhotels/socialmedia"
    static let getHotelQuestionnaire = ServerUrls.baseUrl + "Addhotels/questionnaire"
    static let getContacts = ServerUrls.baseUrl + "Addhotels/contact"
    
    
    static let submitHotelQuestionnaire = ServerUrls.baseUrl + "Addhotels/questionnaires_answers"
    
    static let getCreteExtras = ServerUrls.baseUrl + "Aboutcretes/creteextras"
    static let getCreteExtrasDetail = ServerUrls.baseUrl + "Aboutcretes/creteextrasdetail"
    static let getAboutCrete = ServerUrls.baseUrl + "Aboutcretes/aboutcrete"
    static let getGuideCrete = ServerUrls.baseUrl + "Aboutcretes/guidetocrete"
    static let getGuideCreteBeachArea = ServerUrls.baseUrl + "Aboutcretes/beachesregionbyarea"
    
    static let getMessages = ServerUrls.baseUrl + "Chats/chatview"
    static let getGreekWords = ServerUrls.baseUrl + "Staticpages/greekwords"
    static let getUsefulInfo = ServerUrls.baseUrl + "Staticpages/usefulinfo"
    static let getUsefulNumbers = ServerUrls.baseUrl + "Staticpages/usefulnumbers"
    
    static let getMenuMapList = ServerUrls.baseUrl + "Aboutcretes/maplist"
    static let getPinData = ServerUrls.baseUrl + "Aboutcretes/mapdata"
    
    static let getGuideBeachesByParams = ServerUrls.baseUrl + "Aboutcretes/guidebeachesbyparams"
    static let getGuideCreteRegions = ServerUrls.baseUrl + "Aboutcretes/regionofcrete"
    
    
    
    
}
