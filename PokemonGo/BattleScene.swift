//
//  BattleScene.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 16-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import SpriteKit
import UIKit



class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon : Pokemon!
    
    //Para incorporar el pokemon se crea una varibale de pokemonSprite que estaremos usando en la batalla
    var pokemonSprite : SKNode!
    
    //Para incorporar la pokebola se crea una varibale de pokemonSprite que estaremos usando en la batalla
    var pokeballSprite : SKNode!
    
    //Estas seran las constantes para identificar el tamaño del pokemon y los nombres de los nodos de tioo pokemon y pokeball
    let kPokemonSize : CGSize = CGSize(width: 50, height: 50)
    let kPokemonName : String = "pokemon"
    let kPokeballName : String = "pokeball"
    
    
    //Metodo que inica una scena 
    override func didMove(to view: SKView) {
        //print("Estamos en la scena")
        //Para incorporar fondo de la scena
        backgroundColor = UIColor.green
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bgImage.zPosition = -1
        self.addChild(bgImage)
        
        //Añadir Pokemon Paso 10: lo vamos a llamar despues de un segundo
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 1.0)
        
    }
    
    //Añadir Pokemon Paso 1
    func createPokemon() -> SKNode {
        //Añadir Pokemon Paso 3
        let pokemonSprite = SKSpriteNode(imageNamed: self.pokemon.imageFileName!)
        //Añadir Pokemon Paso 4
        pokemonSprite.size = kPokemonSize
        //Añadir Pokemon Paso 5
        pokemonSprite.name = kPokemonName
        //Añadir Pokemon Paso 6
        return pokemonSprite
    }
    
    //Añadir Pokemon Paso 2
    func setupPokemon () {
        //Añadir Pokemon Paso 7
        self.pokemonSprite = self.createPokemon()
        //Añadir Pokemon Paso 8: para dejar al pokemon en el centro de la pantalla
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        //Añadir Pokemon Paso 11 : Mover el pokemon hacia la derecha
        let moveRight = SKAction.moveBy(x: 150, y: 0, duration: 2.0)
        //Añadir Pokemon Paso 12 : Secuencia de acciones (Derecha, izquierda, derecha, al centro)
        let secuence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        
        //Añadir Pokemon Paso 13 : Para que se ejcute la secuencia por siempre
        self.pokemonSprite.run(SKAction.repeatForever(secuence))
        
        
        //Añadir Pokemon Paso 9: Para agregarlo a la pantalla
        self.addChild(self.pokemonSprite)
    }

}
