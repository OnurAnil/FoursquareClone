//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Onur Anıl on 19.05.2024.
//


//SİNGLETON MODELİ
import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placelatitude = ""
    var placeLongitude = ""
    
    private init(){}
}
