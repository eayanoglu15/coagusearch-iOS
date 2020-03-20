//
//  LoadingViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 16.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    @IBOutlet var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stylize()
        initializeLoadingView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLoadingAnimation()
    }
    
    private func initializeLoadingView() {
        let animation = Animation.named(LOADING_VIEW_JSON_FILE_NAME)
        animationView.animation = animation
        animationView.loopMode = LottieLoopMode.loop
        animationView.backgroundBehavior = .pauseAndRestore
 }

    func startLoadingAnimation() {
        animationView.play()
    }
    
    func stopLoadingAnimation() {
        animationView.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
