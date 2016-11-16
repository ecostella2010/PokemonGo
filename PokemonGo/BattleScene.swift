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
    
    
    //Hacer mas facil el movimiento Paso 1:
    let pokemonPixelsPerSecond  = 75.0
    //Hacer mas facil el movimiento Paso 2:
    let pokemonDistance = 150.0
    
    //40 La fisica videojuego Paso 3: Declarar las constantes de interaccion o categorias de choque
    //Se puede colisionar un pokemon, bordes, pokeball
    
    let kPokemonCategory : UInt32 = 0x1 << 0
    let kPokeballCategory : UInt32 = 0x1 << 1
    let kSceneEdgeCategory : UInt32 = 0x1 << 2
    
    //41 Touch Began y Ended Paso 1:La velocidad de la bola al inicio parada
    var velocity : CGPoint = CGPoint.zero
    //41 Touch Began y Ended Paso 2: Para saber donde toca el usuario y cuanto tiene que tirar
    var touchPoint : CGPoint = CGPoint()
    //41 Touch Began y Ended Paso 3: Para solo permitir tirar cuando tocado la pokeball y la arrastre correctamenre en la pantalla.
    var canThrowPokeball = false
    
    //42 Metodo contact mode Paso 4: Declaramos variable
    var pokemonCaught = false
    
    
    //43 Timer - Cuenta atras Paso 1: Declaramos variable
    var startCount = true
    var maxTime = 30
    var myTime = 30
    var printTime = SKLabelNode(fontNamed: "arial")
    
    
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
        
        
        //43 Timer - Cuenta atras Paso 9: indico la posicion(Centro horizontalmente y en la parte superior) de la etiqueta que indica el tiempo de cuenta atras
        self.printTime.position = CGPoint(x: self.size.width/2.0, y: self.size.height*0.9)
        //43 Timer - Cuenta atras Paso 10: Para agregar el objeto en la interfaz
        self.addChild(self.printTime)
        
        //45 Mensajes y Usabilidad Paso 7: Objeto Mensaje de batalla
        showMessageWith(imageNamed: "battle")
        
        //Añadir Pokemon Paso 10: lo vamos a llamar despues de un segundo
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 1.0)
        
        //Añadir Pokeball Paso 10: lo vamos a llamar despues de un segundo
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 1.0)
        
        //40 La fisica videojuego Paso 1: indica que toda mi pantalla es el limite fisico donde va a incurrir el video juego, esto evitará que la pokeball se escape de la pantalla
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        //40 La fisica videojuego Paso 11: Con lo siguiente queda asignada la categoria al borde de la scena
        self.physicsBody!.categoryBitMask = kSceneEdgeCategory
        
        //40 La fisica videojuego Paso 2: Indicamos que los metodos delegate que administran el contacto fisico seremos nosotros mismos, "SKPhysicsContactDelegate"
        self.physicsWorld.contactDelegate = self
        
        

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
        
        
        //40 La fisica videojuego Paso 4: asignar el valor fisico
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        //40 La fisica videojuego Paso 5: Si se va a estar moviendo constantemente el pokemon, es no porque solo se mueve de izquierda a derecha
        self.pokemonSprite.physicsBody!.isDynamic = false
        //40 La fisica videojuego Paso 6: El pokemon no está afectado por la gravedad, por tanto se mantendrá donde lo posicionemos y no descenderá
        self.pokemonSprite.physicsBody!.affectedByGravity = false
        //40 La fisica videojuego Paso 7: La masa del pokemon, la podriamos incorporar en core data como atributo de cada pokemon, e influiría a la hora de chocar la pokeball contra el pokemon, como revotaria el objeto. self.pokemon.masa
        self.pokemonSprite.physicsBody!.mass = 1.0
        //40 La fisica videojuego Paso 8: Definimos las categoria del pokemon
        self.pokemonSprite.physicsBody!.categoryBitMask = kPokemonCategory
        //40 La fisica videojuego Paso 9: Contra quien debe chocar el pokemon, es decir contra quien puede chocar, la pokeball
        self.pokemonSprite.physicsBody!.contactTestBitMask = kPokeballCategory
        //40 La fisica videojuego Paso 10: Contra quien colisiona o choca por efecto de la fisica, es decir con el borde
        self.pokemonSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        
        
        //Añadir Pokemon Paso 11 : Mover el pokemon hacia la derecha
        //let moveRight = SKAction.moveBy(x:  150, y: 0, duration: 2.0)
        
        //Hacer mas facil el movimiento Paso 3: Movimiento po pixeles
        let moveRight = SKAction.moveBy(x:  CGFloat(pokemonDistance), y: 0, duration: self.pokemonDistance/self.pokemonPixelsPerSecond)
        
        //Añadir Pokemon Paso 12 : Secuencia de acciones (Derecha, izquierda, derecha, al centro)
        let secuence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        
        //Añadir Pokemon Paso 13 : Para que se ejcute la secuencia por siempre
        self.pokemonSprite.run(SKAction.repeatForever(secuence))
        
        //Añadir Pokemon Paso 9: Para agregarlo a la pantalla
        self.addChild(self.pokemonSprite)
    }
    
    //Añadir Pokeball Paso 1
    func createPokeball() -> SKNode {
        //Añadir Pokeball Paso 3
        let pokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        //Añadir Pokeball Paso 4
        pokeballSprite.size = kPokemonSize
        //Añadir Pokeball Paso 5
        pokeballSprite.name = kPokeballName
        //Añadir Pokeball Paso 6
        return pokeballSprite
    }
    
    //Añadir Pokeball Paso 2
    func setupPokeball () {
        //Añadir Pokeball Paso 7
        self.pokeballSprite = self.createPokeball()
        //Añadir Pokeball Paso 8: para dejar la Pokeball en el centro inferior de la pantalla
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: 50)
        
        
        //40 La fisica videojuego Paso 12: asignar el valor fisico - Zona de contacto
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokemonSprite.frame.size.width/2.0)
        //40 La fisica videojuego Paso 13: La pokeball debe rebotar por eso debe ser dinamica
        self.pokeballSprite.physicsBody!.isDynamic = true
        //40 La fisica videojuego Paso 14: La Pokeball esta afectada por la gravedad, está en el piso y al lanzarla debe volver al piso.
        self.pokeballSprite.physicsBody!.affectedByGravity = true
        //40 La fisica videojuego Paso 15: La masa de la pokeball la cual debe ser ligera.
        self.pokeballSprite.physicsBody!.mass = 0.1
        //40 La fisica videojuego Paso 16: Definimos las categoria del pokeball
        self.pokeballSprite.physicsBody!.categoryBitMask = kPokeballCategory
        //40 La fisica videojuego Paso 17: Contra quien debe chocar la pokeball, es decir contra el pokemon
        self.pokeballSprite.physicsBody!.contactTestBitMask = kPokemonCategory
        //40 La fisica videojuego Paso 18: Contra quien colisiona o choca por efecto de la fisica, es decir con el borde y contra el pokemon
        self.pokeballSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory | kPokemonCategory

        
        //Añadir Pokeball Paso 11 : Mover el pokemon hacia la derecha
        //let moveRight = SKAction.moveBy(x: 150, y: 0, duration: 2.0)
        //Añadir Pokeball Paso 12 : Secuencia de acciones (Derecha, izquierda, derecha, al centro)
        //let secuence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        
        //Añadir Pokeball Paso 13 : Para que se ejcute la secuencia por siempre
        //self.pokeballSprite.run(SKAction.repeatForever(secuence))
        
        
        //Añadir Pokeball Paso 9: Para agregarlo a la pantalla
        self.addChild(self.pokeballSprite)
    }
    
    //touchesBegan : Se ejecuta cuando el usuario empieza el toque del dedo en la pantalla
    //touchesMoved : Se ejecuta cuando el usuario mueve el dedo en la pantalla
    //touchesEnd : Se ejecuta cuando el usuario suelda el dedo de la pantalla
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //41 Touch Began y Ended Paso 4: Quedarme con el ultimo toque de la pantalla
        let touch = touches.first
        //41 Touch Began y Ended Paso 5: Donde toco
        let location = touch?.location(in: self)
        //41 Touch Began y Ended Paso 6: Validamos si la pokeball contiene la posicion, en tal caso ha tocado la pokebala
        if self.pokeballSprite.frame.contains(location!){
            //41 Touch Began y Ended Paso 7: Si ha tocado puedo tirar la pokeball
            self.canThrowPokeball = true
            //41 Touch Began y Ended Paso 8: Guardo la posicion del pokeball
            self.touchPoint = location!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //41 Touch Began y Ended Paso 9: Quedarme con el ultimo toque de la pantalla
        let touch = touches.first
        //41 Touch Began y Ended Paso 10: Donde toco
        let location = touch?.location(in: self)
        //41 Touch Began y Ended Paso 11: Actualizo la variable de posicion
        self.touchPoint = location!
        //41 Touch Began y Ended Paso 12: Valido si puedo lanzar la pokeball
        if self.canThrowPokeball {
            //41 Touch Began y Ended Paso 14: lanzo la pokeball
            self.throwPokeball()
        }
        
    }
    //41 Touch Began y Ended Paso 13: Funcion que lanza la pokeball
    func throwPokeball(){
        
        //41 Touch Began y Ended Paso 15: Una vez lanzado debe setearse en false
        self.canThrowPokeball = false
        //41 Touch Began y Ended Paso 16: definimos un diferncial de tiempo. Como de fuerte se tiene que lazar la pokebola
        let dt: CGFloat = 1.0/20.0
        //41 Touch Began y Ended Paso 16: Calculo la distancia de arrastre de la pokeball desde empezó con el primer toque hasta que lo solto. La distancia a la que hay que lanzar la pokebola
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        //41 Touch Began y Ended Paso 17: Defino la velocidad
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
        //41 Touch Began y Ended Paso 18: Asignamos la velocidad a la pokeball
        self.pokeballSprite.physicsBody!.velocity = velocity
        
    }
    
    //42 Metodo contact mode Paso 1: Contacto entre 2 elementos
    func didBegin(_ contact: SKPhysicsContact) {
        //42 Metodo contact mode Paso 2: Obtenemos los contactos
        let contactMark = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        //42 Metodo contact mode Paso 3: Validamos los tipos de objetos contactados
        switch contactMark {
        case kPokemonCategory|kPokeballCategory:
            print ("Capturado")
            //42 Metodo contact mode Paso 5: Actualizamos valor
            self.pokemonCaught = true
            //42 Metodo contact mode Paso 7: Finalizamos la escena del juego
            endGame()
        default:
            return
        }
    }
    
    //43 Timer - Cuenta atras Paso 2: Metodo Update usado en videojuegos 60 veces por segundos
    override func update(_ currentTime: TimeInterval) {
        //43 Timer - Cuenta atras Paso 3: Valido si comienzo a contar
        if self.startCount {
            //43 Timer - Cuenta atras Paso 4: Añado al maxTiempo el tiemoo actual
            self.maxTime = Int(currentTime) + self.maxTime
            //43 Timer - Cuenta atras Paso 5: Vuelvo a falso la variable para que no pasa de nuevo en esta misma escena
            self.startCount = false
        }
         //43 Timer - Cuenta atras Paso 5: Asigno a my tiempo el max tiempo menos el tiempo actual
        self.myTime = self.maxTime - Int(currentTime)
         //43 Timer - Cuenta atras Paso 6: Despliego el tiempo de cuenta regresiva
        self.printTime.text = "\(self.myTime)"
         //43 Timer - Cuenta atras Paso 7: Si no queda tiempo se finaliza la escena y el pokemon escapa.
        if self.myTime <= 0 {
             //43 Timer - Cuenta atras Paso 8: Finaliza la scene
            endGame()
        }
    }
    
    //42 Metodo contact mode Paso 6: Definimos funcion endGame
    func endGame(){
        
        //44 Fin de la batalla con notificaciones Paso 1:
        self.pokemonSprite.removeFromParent()
        self.pokeballSprite.removeFromParent()
        
        
        //43 Timer - Cuenta atras Paso 11:
        if self.pokemonCaught {
            //46 Pokemon Capturado Paso 0 :
            self.pokemonCaught = false
            print ("Pokemon Capturado")
            //46 Pokemon Capturado Paso 1 : incrementamos
            self.pokemon.timesCaught += 1
            //46 Pokemon Capturado Paso 2 : persistencia en core data
             (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //45 Mensajes y Usabilidad Paso 8: Mensaje Capturado
            showMessageWith(imageNamed: "gotcha")
        }
        else{
            //46 Pokemon Capturado Paso 0 :
            self.pokemonCaught = false
            print ("Me he quedado sin tiempo")
            //45 Mensajes y Usabilidad Paso 9: Mensaje Escapado
            showMessageWith(imageNamed: "footprints")
        }
        //44 Fin de la batalla con notificaciones Paso 6: termina la batalla
        self.perform(#selector(endBattle), with: nil, afterDelay: 2.0)
    }
    
    //45 Mensajes y Usabilidad Paso 1: Objeto Mensaje
    func showMessageWith(imageNamed: String) {
        //45 Mensajes y Usabilidad Paso 2: Objeto Mensaje de batalla
        let message = SKSpriteNode(imageNamed: imageNamed)
        //45 Mensajes y Usabilidad Paso 3: Tamaño
        message.size = CGSize(width: 150, height: 150)
        //45 Mensajes y Usabilidad Paso 4: Posicion
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        //45 Mensajes y Usabilidad Paso 5: Para agregar el objeto en la interfaz
        self.addChild(message)
        //45 Mensajes y Usabilidad Paso 6: Despliegue por 1 segundo
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
    //44 Fin de la batalla con notificaciones Paso 2:
    func endBattle() {
        //44 Fin de la batalla con notificaciones Paso 5: Envia Notificacion de closeBattle
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"), object: nil)
    }
    
}
