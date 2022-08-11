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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(showTheaterList))
        
        
        
        
        
        
        let center = CLLocationCoordinate2D(latitude: 37.517662, longitude: 126.886936)
        setRegionAndAnnotation(center: center)
        locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func showTheaterList() {
        let showTheaterAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let showMegaBox = UIAlertAction(title: "메가박스", style: .default)
        let showLotteCinemma = UIAlertAction(title: "롯데시네마", style: .default)
        let showCGV = UIAlertAction(title: "CGV", style: .default)
        let showAll = UIAlertAction(title: "전체보기", style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        showTheaterAlert.addAction(showMegaBox)
        showTheaterAlert.addAction(showLotteCinemma)
        showTheaterAlert.addAction(showCGV)
        showTheaterAlert.addAction(showAll)
        showTheaterAlert.addAction(cancel)
        
        present(showTheaterAlert, animated: true, completion: nil)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "캠퍼스!!!"
        
        mapView.addAnnotation(annotation)
    }
    
   func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Location5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
    }
}

extension MapViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
        print(#function)
    }
    
}
