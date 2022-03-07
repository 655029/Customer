//
//  BlurConfirmationAlertViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 11/11/21.
//

import Foundation
import UIKit

class BlurModalPresentation: NSObject,UIViewControllerAnimatedTransitioning {


        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{

            return 0.5
        }

//This is the blur view used for transition
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
        var destinationView : UIView!
        var animator: UIViewPropertyAnimator?

        // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning){

            let containerView = transitionContext.containerView

            _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)

            destinationView = toVc!.view
            destinationView.alpha = 0.0

//Here we add the blur view and set it effect to nil
            blurView.effect = nil
            blurView.frame = containerView.bounds

            self.blurTransition(transitionContext) {

                self.unBlur(transitionContext, completion: {

                    self.blurView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }

            containerView.addSubview(toVc!.view)
            containerView.addSubview(blurView)
        }

        //This methods add the blur to our view and our destinationView
        func blurTransition(_ context : UIViewControllerContextTransitioning,completion: @escaping () -> Void){

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.transitionDuration(using: context)/2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {

                self.destinationView.alpha = 0.5
                self.blurView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
            }, completion: { (position) in
                completion()
            })

        }
        //This Method remove the blur view with an animation
        func unBlur(_ context : UIViewControllerContextTransitioning,completion: @escaping () -> Void){

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.transitionDuration(using: context) / 2, delay:0, options: UIView.AnimationOptions.curveLinear, animations: {

                self.destinationView.alpha = 1.0
                self.blurView.effect = nil
            }, completion: { (position) in
                completion()
            })
        }

    }
