//
//  CardsViewController.swift
//  MockTinder
//
//  Created by Daniel Calderon on 3/14/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    var cardInitialCenter: CGPoint!

    @IBOutlet weak var pictureImageView: UIImageView!
    var fadeTransition: FadeTransition!
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pictureImageView.layer.cornerRadius = 11

        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        pictureImageView.isUserInteractionEnabled = true
        pictureImageView.addGestureRecognizer(panGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: view)
        
        if sender.state == .began{
            cardInitialCenter = self.pictureImageView.center
        }
            
        else if sender.state == .changed{
            self.pictureImageView.center = CGPoint(x: cardInitialCenter.x + translate.x, y: cardInitialCenter.y + translate.y)
            self.pictureImageView.transform = CGAffineTransform(rotationAngle: translate.x / 20 * (CGFloat.pi / 180.0))
            print("Translate x: \(translate.x)")
        }
            
        else if sender.state == .ended{
            
            if(translate.x > 100){
                UIView.animate(withDuration: 0.25, animations: {
                    self.pictureImageView.transform = self.pictureImageView.transform.translatedBy(x: 400, y: 0)
                }, completion: { (done) in
                    self.pictureImageView.removeFromSuperview()
                })
            }
            else if(translate.x < -100){
                UIView.animate(withDuration: 0.25, animations: {
                    self.pictureImageView.transform = self.pictureImageView.transform.translatedBy(x: -400, y: 0)
                }, completion: { (done) in
                    self.pictureImageView.removeFromSuperview()
                })
            }
                
            else{
                UIView.animate(withDuration: 0.4, animations: {
                    self.pictureImageView.center = self.cardInitialCenter
                    self.pictureImageView.transform = CGAffineTransform.identity
                }, completion: { (done) in
                    
                })
            }
        }
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "profileSegue", sender: sender)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ProfileViewController
        destVC.modalPresentationStyle = UIModalPresentationStyle.custom
        fadeTransition = FadeTransition()
        destVC.transitioningDelegate = fadeTransition
        fadeTransition.duration = 0.4
        destVC.profileImage = self.pictureImageView.image
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
