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
    
    createPokemon (name: "Abra", with: "abra")
    createPokemon (name: "Bellsprout", with: "bellsprout")
    createPokemon (name: "Bullbasaur", with: "bullbasaur")
    createPokemon (name: "Caterpie", with: "caterpie")
    createPokemon (name: "Charmander", with: "charmander")
    createPokemon (name: "Jigglypuff", with: "jigglypuff")
    createPokemon (name: "Meowth", with: "meowth")
    createPokemon (name: "Mew", with: "mew")
    createPokemon (name: "Pikachu", with: "pikachu-2")
    createPokemon (name: "Squirtle", with: "squirtle")
    createPokemon (name: "Snorlax", with: "snorlax")
    createPokemon (name: "Zubat", with: "zubat")
    createPokemon (name: "Dratini", with: "dratini")
    createPokemon (name: "Eevee", with: "eevee")
    createPokemon (name: "Mankey", with: "mankey")
    createPokemon (name: "Pidgey", with: "pidgey")
    createPokemon (name: "Psyduck", with: "psyduck")
    createPokemon (name: "Rattata", with: "rattata")
    createPokemon (name: "Venonat", with: "venonat")
    createPokemon (name: "Weedle", with: "weedle")
    
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    
    
}

func createPokemon(name:String, with imageNamed:String) {
    //Esta se encargará de sacar los pokemon de core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    
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





