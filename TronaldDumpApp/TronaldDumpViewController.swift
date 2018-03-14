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

class TronaldDumpViewController: UIViewController {
    
    let tronaldDumpHTTP = "https://api.tronalddump.io/random/quote"

    @IBOutlet weak var tronaldDumpImage: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRandomQuote()
    }
    
    //MARK: - Fetch New Button
    /***************************************************************/
    
    @IBAction func fetchNewQuote(_ sender: UIButton) {
        
        getRandomQuote()
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    func getRandomQuote() {
        
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

}

