//
//  CoreDateHelper.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 15-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit
import CoreData

func createAllPokemons () {
    
    //54 No todos los pokemon son iguales Paso 3: agregar parametro frecuency
    createPokemon (name: "Abra", with: "abra",frecuency: 70)
    createPokemon (name: "Bellsprout", with: "bellsprout",frecuency: 80)
    createPokemon (name: "Bullbasaur", with: "bullbasaur",frecuency: 22)
    createPokemon (name: "Caterpie", with: "caterpie",frecuency: 84)
    createPokemon (name: "Charmander", with: "charmander",frecuency: 17)
    createPokemon (name: "Jigglypuff", with: "jigglypuff",frecuency: 67)
    createPokemon (name: "Meowth", with: "meowth",frecuency: 65)
    createPokemon (name: "Mew", with: "mew",frecuency: 1)
    createPokemon (name: "Pikachu", with: "pikachu-2",frecuency: 8)
    createPokemon (name: "Squirtle", with: "squirtle",frecuency: 20)
    createPokemon (name: "Snorlax", with: "snorlax",frecuency: 3)
    createPokemon (name: "Zubat", with: "zubat",frecuency: 100)
    createPokemon (name: "Dratini", with: "dratini",frecuency: 2)
    createPokemon (name: "Eevee", with: "eevee",frecuency: 4)
    createPokemon (name: "Mankey", with: "mankey",frecuency: 60)
    createPokemon (name: "Pidgey", with: "pidgey",frecuency: 85)
    createPokemon (name: "Psyduck", with: "psyduck",frecuency: 50)
    createPokemon (name: "Rattata", with: "rattata",frecuency: 95)
    createPokemon (name: "Venonat", with: "venonat",frecuency: 76)
    createPokemon (name: "Weedle", with: "weedle",frecuency: 78)
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    
    
}

//54 No todos los pokemon son iguales Paso 2: agregar parametro frecuency
func createPokemon(name:String, with imageNamed:String, frecuency: Int16) {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.frecuency = frecuency
    
}

/*
func createAndCaughtPokemon(name:String, with imageNamed:String) {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.timesCaught = 1
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}
*/


func getAllPokemons() -> [Pokemon] {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            createAllPokemons()
            return getAllPokemons()
        }
        return pokemons
    }
    catch {
        print("Ha habido un problema al recuperar los pokemons de core data")
    }
    return []
}

func getAllCaughtPokemons() -> [Pokemon] {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d",0)
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }
    catch {
        print("Ha habido un problema al recuperar los pokemons de core data")
    }
    return []
}

func getAllUncaughtPokemons() -> [Pokemon] {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d",0)
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }
    catch {
        print("Ha habido un problema al recuperar los pokemons de core data")
    }
    return []
}





