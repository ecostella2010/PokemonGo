//
//  ViewController.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 15-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    //Este no va a decir la posicion del usuario, por lo que el view controller va actuar segun lo que le indica el manager, esto es un patron de delegados
    var manager = CLLocationManager()
    
    
    var updateCount = 0
    let mapDistance : CLLocationDistance = 300
    var pokemonSpanTimer : TimeInterval = 5
    
    //Creamos el arreglo de pokemones que trabajaremos en pantalla
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        //Creamos la base de pokemones en core data local
        //createAllPokemons()
        
        
        //Recuperar pokemon de core data
        pokemons = getAllPokemons()
        
        //Siempre pide permiso a pesar que la app esta cerrada. Este usa mucha bateria.
        //self.manager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Estamos listos para salir a cszar Pokemons")
            self.mapView.showsUserLocation = true
            //Esto estará monitoreando el cambio de posicion del usuario
            self.manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: pokemonSpanTimer, repeats: true, block: { (timer) in
                //Hay que generar un nuevo pokemon¡¡¡
                print("Generando un nuevo pokemon")
                
                //Con el siguiente codigo vamos agregar una chincheta o pokemon encima del jugador
                if let coordinate = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    //Hacia Arriba, sin embargo las distancias deberian ser aleatorias
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0)/400000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0)/400000.0

                    //Hacia Abajo o al sur sin embargo las distancias deberian ser aleatorias
                    //annotation.coordinate.latitude -= 0.001
                    //annotation.coordinate.longitude -= 0.001

                    
                    
                    //Lo mostramos en el mapa
                    self.mapView.addAnnotation(annotation)
                }
                
                
            })
            
        }
        else {
            //Siempre que la app esta en uso.
            self.manager.requestWhenInUseAuthorization()
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Core Location Manager delegate
    //Este metodo se llamará cada vez que el usuario se mueve y nuestro manager lo detecte
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print ("Me he actualizado la posicion")
        
        //Para que posiicone al usuario una sola vez
        if updateCount < 4 {
        
            
            if let coordinate = self.manager.location?.coordinate {
                //Localizacion del usuario en una regiomn de 100 metros hacia arriba - abajo y 1000 metros hacia derecha e izquierda
                let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
                //Actualizo la posiicon en el mapa
                self.mapView.setRegion(region, animated: true)
                updateCount += 1
            } else {
                //Con esto paramos qe se actualice el mapa segun los movimientos del usuario, sin embargo el usuario igual se seguira moviendo en el mapa.
                self.manager.stopUpdatingLocation()
            }
        }
    }
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        
        
        if let coordinate = self.manager.location?.coordinate
        {
            //Localizacion del usuario en una regiomn de 100 metros hacia arriba - abajo y 1000 metros hacia derecha e izquierda
            let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
            //Actualizo la posiicon en el mapa
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

