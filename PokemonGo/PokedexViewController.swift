//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by Eduardo Costella on 15-11-16.
//  Copyright © 2016 Eduardo Costella. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inicializamos
        self.caughtPokemons = getAllCaughtPokemons()
        self.uncaughtPokemons = getAllUncaughtPokemons()
        
        print("Capturados : \(self.caughtPokemons.count)")
        print("No Capturados : \(self.uncaughtPokemons.count)")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if  section == 0 {
            return "Capturados"
        } else {
            return "No Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0 {
            return self.caughtPokemons.count
        } else {
            return self.uncaughtPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
        
        
        var pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.caughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = "Veces capturado :\(pokemon.timesCaught)"
        }else {
            pokemon = self.uncaughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = ""
        }
        
        //cell.textLabel?.text = pokemon.name
        //cell.imageView?.image = UIImage(named: pokemon.imageFileName!)
        
        //Las anterioes se reemplazan por las personalizadas en el PokemonTableViewCell
        cell.pokemonNameLabel.text = pokemon.name
        cell.pokemonImageView?.image = UIImage(named: pokemon.imageFileName!)
        
        
        return cell
        
        //Necesitamos agregar un objeto table view cell en el storyBoard 
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToMapPressed(_ sender: UIButton) {
        
        //Para que se vuelva atras
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
