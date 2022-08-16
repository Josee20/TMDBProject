//
//  MapViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/11.
//

import UIKit
import MapKit
import CoreLocation


struct Theater {
    let type: String
    let location: String
    let latitude: Double
    let longitude: Double
}

struct TheaterList {
    var mapAnnotations: [Theater] = [
        Theater(type: "롯데시네마", location: "롯데시네마 서울대입구", latitude: 37.4824761978647, longitude: 126.9521680487202),
        Theater(type: "롯데시네마", location: "롯데시네마 가산디지털", latitude: 37.47947929602294, longitude: 126.88891083192269),
        Theater(type: "메가박스", location: "메가박스 이수", latitude: 37.48581351541419, longitude:  126.98092132899579),
        Theater(type: "메가박스", location: "메가박스 강남", latitude: 37.49948523972615, longitude: 127.02570417165666),
        Theater(type: "CGV", location: "CGV 영등포", latitude: 37.52666023337906, longitude: 126.9258351013706),
        Theater(type: "CGV", location: "CGV 용산 아이파크몰", latitude: 37.53149302830903, longitude: 126.9654030486416)
    ]
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var theaterList = TheaterList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(showTheaterList))

        let center = CLLocationCoordinate2D(latitude: 37.517662, longitude: 126.886936)
        setRegionAndAnnotation(center: center, theaterName: "영등포 캠퍼스")
        checkUserDeviceLocationServiceAuthorization()
 
    }
    
    @objc func showTheaterList() {
        let showTheaterAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let showMegaBox = UIAlertAction(title: "메가박스", style: .default) { showMegaBox in
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for i in 2...3 {
                let positionMegaBox = CLLocationCoordinate2D(latitude: self.theaterList.mapAnnotations[i].latitude, longitude: self.theaterList.mapAnnotations[i].longitude)
                self.setRegionAndAnnotation(center: positionMegaBox, theaterName: self.theaterList.mapAnnotations[i].location)
            }
        }
        let showLotteCinemma = UIAlertAction(title: "롯데시네마", style: .default) { showLotteCinemma in
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for i in 0...1 {
                let positionLotteCinemma = CLLocationCoordinate2D(latitude: self.theaterList.mapAnnotations[i].latitude, longitude: self.theaterList.mapAnnotations[i].longitude)
                self.setRegionAndAnnotation(center: positionLotteCinemma, theaterName: self.theaterList.mapAnnotations[i].location)
            }
        }
        let showCGV = UIAlertAction(title: "CGV", style: .default) { showCGV in
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for i in 4...5 {
                let positionCGV = CLLocationCoordinate2D(latitude: self.theaterList.mapAnnotations[i].latitude, longitude: self.theaterList.mapAnnotations[i].longitude)
                self.setRegionAndAnnotation(center: positionCGV, theaterName: self.theaterList.mapAnnotations[i].location)
            }
        }
        let showAll = UIAlertAction(title: "전체보기", style: .default) { showAll in
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for i in 0..<self.theaterList.mapAnnotations.count {
                let positionAll = CLLocationCoordinate2D(latitude: self.theaterList.mapAnnotations[i].latitude, longitude: self.theaterList.mapAnnotations[i].longitude)
                self.setRegionAndAnnotation(center: positionAll, theaterName: self.theaterList.mapAnnotations[i].location)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        showTheaterAlert.addAction(showMegaBox)
        showTheaterAlert.addAction(showLotteCinemma)
        showTheaterAlert.addAction(showCGV)
        showTheaterAlert.addAction(showAll)
        showTheaterAlert.addAction(cancel)
        
        present(showTheaterAlert, animated: true, completion: nil)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D, theaterName: String) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 14000, longitudinalMeters: 14000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = theaterName
        
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져있어 권한요청을 할 수 없습니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DENIED", "아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
    
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations, "위치를 성공적으로 가져왔습니다.")
        print(locations.last?.coordinate)
        
        
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate, theaterName: "내 위치")
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "위치를 가져오는데 실패했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "권한변화")
        checkUserDeviceLocationServiceAuthorization()
    }
}

//extension MapViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }

//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        locationManager.startUpdatingLocation()
//    }
//}
