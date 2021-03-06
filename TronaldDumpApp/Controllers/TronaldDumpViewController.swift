//
//  TronaldDumpViewController.swift
//  TronaldDumpApp
//
//  Created by Žan Fras on 14/03/2018.
//  Copyright © 2018 Žan Fras. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SVProgressHUD

class TronaldDumpViewController: UIViewController {
    
    var faves = [Fave]()
    
    let tronaldDumpHTTP = "https://api.tronalddump.io/random/quote"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tronaldDumpImage: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRandomQuote()
    }
    
    //MARK: - Fetch New Button
    /***************************************************************/
    
    @IBAction func fetchNewQuote(_ sender: UIBarButtonItem) {
        
        getRandomQuote()
        
    }
    
    
    //MARK: - Fave the Quote
    /***************************************************************/
    
    @IBAction func faveTheQuote(_ sender: UIButton) {
        
        if faves.contains(where: { $0.quote == quoteLabel.text! }) {
            SVProgressHUD.showInfo(withStatus: "Quote already faved.")
            SVProgressHUD.dismiss(withDelay: 1)
        } else {
            let newFaveQuote = Fave(context: context)
            newFaveQuote.quote = quoteLabel.text!
            
            faves.append(newFaveQuote)
            
            saveFaveQuote()
            
            SVProgressHUD.showSuccess(withStatus: "Quote faved.")
            SVProgressHUD.dismiss(withDelay: 1, completion: {
                self.getRandomQuote()
            })
        }
        
    }    
    
    
    //MARK: - Networking
    /***************************************************************/
    func getRandomQuote() {
        
        loadFaves()
        
        Alamofire.request(tronaldDumpHTTP, method: .get, parameters: nil).responseJSON { (response) in
            if response.result.isSuccess {
                let quoteJSON = JSON(response.result.value!)
                
                self.getQuoteFromJSON(json: quoteJSON)
            } else {
                print("Error fetching quote, \(response.result.error!)")
            }
        }
        
    }
    
    //MARK: - JSON
    /***************************************************************/
    
    func getQuoteFromJSON(json: JSON) {
        
        let quote = json["value"].stringValue
        
        updateQuoteLabel(with: quote)
        
    }
    
    //MARK: - Update UI
    /***************************************************************/

    func updateQuoteLabel(with quote: String) {
        
        quoteLabel.text = quote
        
    }
    
    //MARK: - Data Manipulation Methods
    /***************************************************************/
    
    func saveFaveQuote() {
        
        do {
            try context.save()
        } catch {
            print("Error saving quote, \(error)")
        }
        
    }
    
    func loadFaves(with request: NSFetchRequest<Fave> = Fave.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let request: NSFetchRequest<Fave> = Fave.fetchRequest()
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            faves = try context.fetch(request)
        } catch {
            print("Error loading faves, \(error)")
        }
        
    }

}

