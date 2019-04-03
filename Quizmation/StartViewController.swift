//
//  ViewController.swift
//  Quizmation
//
//  Created by Ammar AlTahhan on 03/04/2019.
//  Copyright © 2019 Ammar AlTahhan. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuestions()
    }
    
    private func loadQuestions() {
        do {
            let url = Bundle.main.url(forResource: "data", withExtension: "json")!
            let data = try Data.init(contentsOf: url)
            questions = try JSONDecoder().decode([Question].self, from: data)
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start",
            let vc = segue.destination as? GameViewController {
            vc.username = usernameTextField.text
            vc.questions = questions
        }
    }
    
}

