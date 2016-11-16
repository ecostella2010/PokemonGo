//
//  BattleViewController.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 16-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    //Para que la scene conozca el pokemon que se quiere capturar creamos la siguiente variable 
    var pokemon : Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lo primero es instanciar la BattleScene, pasandole los tamaños ya que la scena no conoce nada de los tamaños de quien lo esta gobernando, por tanto, con lo siguienre le decimos a la scena te vas a incrustar con los siguientes tamaños
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        //Preparar la vista para mostrar la scena
        self.view = SKView()
        
        //Definir la vista y configurarla
        let skView = self.view as! SKView
        
        //Para centrarnos en la batallas los vamos a poner a false
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        
        //Hace mucho mas rapido la carga de pantallas
        skView.ignoresSiblingOrder = false
        
        scene.scaleMode = .aspectFill
        //Con esto le pasamos a la scene el pokemon
        scene.pokemon = self.pokemon
        
        //Presenta la scene
        skView.presentScene(scene)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
