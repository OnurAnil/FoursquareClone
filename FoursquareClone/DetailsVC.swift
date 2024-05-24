//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Onur Anıl on 14.05.2024.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var choosenPlacesId = ""
    
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getDataFromParse()
        detailsMapView.delegate = self
        
    }
    
    func getDataFromParse(){
        //VERİ AKTARIMI
                let query = PFQuery(className: "Places")
                query.whereKey("objectId", equalTo: choosenPlacesId)
                query.findObjectsInBackground { objects, error in
                    if error != nil {
                        
                    }else{
                        if objects != nil {
                            if objects!.count > 0 {
                                let choosenPlaceObject = objects![0]
                                
                                //OBJELERİ ALMAK
                                
                                if let placeName =  choosenPlaceObject.object(forKey: "name") as? String{
                                    self.detailsNameLabel.text = placeName
                                }
                                if let placeType =  choosenPlaceObject.object(forKey: "type") as? String{
                                    self.detailTypeLabel.text = placeType
                                }
                                if let placeAtmosphere =  choosenPlaceObject.object(forKey: "atmosphere") as? String{
                                    self.detailsAtmosphereLabel.text = placeAtmosphere
                                }
                                
                                if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String {
                                    if let placeLatitudeDouble = Double(placeLatitude){
                                        self.choosenLatitude = placeLatitudeDouble
                                    }
                                }
                                if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String {
                                    if let placeLongitudeDouble = Double(placeLongitude){
                                        self.choosenLongitude = placeLongitudeDouble
                                    }
                                }
                                // KAYDEDİLEN GÖRSELİ GÖSTERMEK
                                if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject {
                                    imageData.getDataInBackground { data, error in
                                        if error == nil {
                                            if data != nil {
                                                self.detailsImageView.image = UIImage(data: data!)
                                            }
                                        }
                                    }
                                }
                                
                                //MAP KONUMU ALMA
                                let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                                
                                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                                
                                let region = MKCoordinateRegion(center: location, span: span)
                                
                                self.detailsMapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = location
                                annotation.title = self.detailsNameLabel.text!
                                annotation.title = self.detailTypeLabel.text!
                                self.detailsMapView.addAnnotation(annotation)
                                
                            }
                        }
                    }
                }
            }
    
   //PİN ÜZERİNE TIKLANINCA DETAYLARI AÇTIRMAK İÇİN
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    //PİNDEN DETAYLARINDAN HARİTALARA GEÇMEK İÇİN
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text!
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
}
