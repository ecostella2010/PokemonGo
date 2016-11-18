//
//  ViewController.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 15-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    //Este no va a decir la posicion del usuario, por lo que el view controller va actuar segun lo que le indica el manager, esto es un patron de delegados
    var manager = CLLocationManager()
    
    var updateCount = 0
    let mapDistance : CLLocationDistance = 300
    //Este solo para desarrollo y prueba a 1500 despues debe volver a 150
    let captureDistance : CLLocationDistance = 150
    var pokemonSpanTimer : TimeInterval = 5
 
    //Creamos el arreglo de pokemones que trabajaremos en pantalla
    var pokemons : [Pokemon] = []
    
    //49 Bug Aparece doble pokemon Paso 1: Declaro Variable
    var hasStartedTheMap = false
    
    //55 Frecuencia Total de Aparicion Paso 1: Variable
    var totalFrecuency = 0
    
    //58 Pausar el juego cuando nos vamos a otro pantalla Paso 1:
    var timer : Timer!
    
    //58 Pausar el juego cuando nos vamos a otro pantalla Paso 9:
    var haveMovedToOtherView = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        //Creamos la base de pokemones en core data local
        //createAllPokemons()
        
        //Recuperar pokemon de core data
        self.pokemons = getAllPokemons()
        
        //55 Frecuencia Total de Aparicion Paso 2: Sumamos frecuencia
        for p in self.pokemons{
            self.totalFrecuency += Int(p.frecuency)
            //print("\(p.name) -  \(p.frecuency)")
        }
        
        //print("Total Freq: \(self.totalFrecuency)")
        //Total Freq: 987
        
        //Siempre pide permiso a pesar que la app esta cerrada. Este usa mucha bateria.
        //self.manager.requestAlwaysAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //48 El bug de la primera vez Paso 4 : El codigo se lleva a funcion para ser reutilizada y luego se invoca la funcion
            self.setupMap()
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

    // MARK: Core Location Manager delegate
    //Este metodo se llamará cada vez que el usuario se mueve y nuestro manager lo detecte
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print ("Me he actualizado la posicion")
        
        //Para que posiicone al usuario una sola vez
        if updateCount < 4 {
        
            
            if let coordinate = self.manager.location?.coordinate {
                //Localizacion del usuario en una regiomn de 100 metros hacia arriba - abajo y 1000 metros hacia derecha e izquierda
                let region = MKCoordinateRegionMakeWithDistance(coordinate, mapDistance, mapDistance)
                //Actualizo la posiicon en el mapa
                self.mapView.setRegion(region, animated: false)
                updateCount += 1
            } else {
                //Con esto paramos qe se actualice el mapa segun los movimientos del usuario, sin embargo el usuario igual se seguira moviendo en el mapa.
                self.manager.stopUpdatingLocation()
            }
        }
    }
    
    //48 El bug de la primera vez Paso 1 :
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //48 El bug de la primera vez Paso 6 :
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //48 El bug de la primera vez Paso 7 : Se configra el mapa
            self.setupMap()
        }
    }
    
    //58 Pausar el juego cuando nos vamos a otro pantalla Paso 3:
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //58 Pausar el juego cuando nos vamos a otro pantalla Paso 4:
        self.timer.invalidate()
        self.haveMovedToOtherView = true
    }
    
    //58 Pausar el juego cuando nos vamos a otro pantalla Paso 5:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //58 Pausar el juego cuando nos vamos a otro pantalla Paso 8: Est€ no debe llamrse la primera vez
        if self.haveMovedToOtherView {
            self.startTimer()
            //58 Pausar el juego cuando nos vamos a otro pantalla Paso 10: Est€ no debe llamrse la primera vez
            self.haveMovedToOtherView = true
            
        }
    }
    
    //48 El bug de la primera vez Paso 2 :
    func setupMap(){
        
        //49 Bug Aparece doble pokemon Paso 2: Valido
        if !self.hasStartedTheMap {
            //49 Bug Aparece doble pokemon Paso 3: Para que no lo haga por segunda vez
            self.hasStartedTheMap = true
            
            //48 El bug de la primera vez Paso 3 :
            //print("Estamos listos para salir a cszar Pokemons")
            //Para tomar el control de los pinchos (La cara de chincheta, que debe mostrarse y que no) debemos primero tomar el control del delegate del mapa, para en esta vista debemos incorporar arriba las funciones del delegate
            self.mapView.delegate = self
        
            self.mapView.showsUserLocation = true
            //Esto estará monitoreando el cambio de posicion del usuario
            self.manager.startUpdatingLocation()
            
             //58 Pausar el juego cuando nos vamos a otro pantalla Paso 7:
            self.startTimer()
        }
    }
    
     //58 Pausar el juego cuando nos vamos a otro pantalla Paso 6:
    func startTimer(){
         //58 Pausar el juego cuando nos vamos a otro pantalla Paso 2:
        self.timer = Timer.scheduledTimer(withTimeInterval: pokemonSpanTimer, repeats: true, block: { (timer) in
            //Hay que generar un nuevo pokemon¡¡¡
            //print("Generando un nuevo pokemon")
            
            //Con el siguiente codigo vamos agregar una chincheta o pokemon encima del jugador
            if let coordinate = self.manager.location?.coordinate {
                
                //Ahora comentamos el siguiente
                //let annotation = MKPointAnnotation()
                //annotation.coordinate = coordinate
                
                //56 Cambiando la frecuencia de cada pokemon Paso 1:
                let randomNumber = Int(arc4random_uniform(UInt32(self.totalFrecuency)))
                var pokemonFrecuenciesAcum = 0
                //pokemon inicializado
                var pokemon : Pokemon = self.pokemons[0]
                for p in self.pokemons  {
                    pokemon = p
                    pokemonFrecuenciesAcum += Int(p.frecuency)
                    if pokemonFrecuenciesAcum >= randomNumber {
                        break
                    }
                }
                //let randonPos = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                //let pokemon = self.pokemons[randonPos]
                
                
                let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                
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
    
    // MARK: Map View Delegate - Para cambiar las imagenes a los pinchos
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annotationView.image =  #imageLiteral(resourceName: "player")
        } else {
            
            //Aqui vamos a recuperar el pokemon aleatorio de arriba
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image =  UIImage(named: pokemon.imageFileName!)
            //annotationView.image =  #imageLiteral(resourceName: "squirtle")
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Permite seleccionar mas de una vez el mismo pokemon
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        //Para que no seleccione al usuario
        if view.annotation! is MKUserLocation {
            return
        }
        
        //Localizacion del usuario en una regiomn de 100 metros hacia arriba - abajo y 1000 metros hacia derecha e izquierda
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, captureDistance, captureDistance)
        //Actualizo la posiicon en el mapa
        self.mapView.setRegion(region, animated: true)
        
        if let coordinate = self.manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) {
                //print("Podemos capturar el pokemon")
                
                //Aqui nos comunicamos con BattleViewController, sin embargo la BattleScene debe conecer que pokemon queremos capturar
                let vc = BattleViewController()
                
                //Del mapa sacamos el pokemon
                vc.pokemon = (view.annotation! as! PokemonAnnotation).pokemon
                
                //47 Alertas y ayudas al usuario Paso 1 : Permite ocultar el pokemon que pinchamos para poder capturarlo
                self.mapView.removeAnnotation(view.annotation!)
                
                self.present(vc, animated: true, completion: nil)
                
            }
            
            else {
                print("Demasiado lejos para cazar ese pokemon")
                //47 Alertas y ayudas al usuario Paso 2 : Mostramos mensaje al usuario cuando esta demasiado lejos
                let pokemon = (view.annotation! as! PokemonAnnotation).pokemon
                let alertController = UIAlertController(title: "Estás demasiado lejos!", message: "Acercate  ese \(pokemon.name!) para poder capturarlo.", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OkAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
        }
        //print("Hemos seleccionado un pincho")
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

