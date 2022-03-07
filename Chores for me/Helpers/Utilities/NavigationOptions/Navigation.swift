//
//  Navigation.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit

enum Navigation: Navigatable {
    case login
    case register
    case twosetpVerification
    case allowLocation
    case forgotPassword
    case forgotPasswordOTP
    case resetPassword
    case chooseYourCity
    case chooseLocationOnMap
    case chooseService
    case chooseSubService(service: Service)
    case chooseAddCustomService(service: Service)
    case addCustomCategory
    case uploadProfilePicture
    case updateJob
    case uploadIDProof
    case jobStatus(jobData: JobHistoryData)
    case cancelJobRequest
    case notifications
    case logout
    case jobstatus
    case choresID
    case providerList
    case ProfileTapped
    case checkOut
    case paymentMode
    case HomePage
    case DoneJob
    case EditButtonTapped
    case CancelReasonPage
    case Rating
    case paymentList
    case cancelPayment
    case googleSignUp
    case facebookSignUp
}

struct AppNavigation: AppNavigatable {
    
    func viewcontrollerForNavigation(navigation: Navigatable) -> UIViewController {
        if let navigation = navigation as? Navigation {
            switch navigation {
            case .login:
                return Storyboard.Authentication.viewController(for: LoginViewController.self)
            case .register:
                return Storyboard.Authentication.viewController(for: RegisterViewController.self)
            case .twosetpVerification:
                return Storyboard.Authentication.viewController(for: TwoStepVerificationViewController.self)
            case .allowLocation:
                return Storyboard.Authentication.viewController(for: AllowLocationViewController.self)
            case .forgotPassword:
                return Storyboard.Authentication.viewController(for: ForgotPasswordViewController.self)
            case .forgotPasswordOTP:
                return Storyboard.Authentication.viewController(for: ForgotPasswordOTPViewController.self)
            case .resetPassword:
                return Storyboard.Authentication.viewController(for: ResetPasswordViewController.self)
            case .chooseYourCity:
                return Storyboard.Location.viewController(for: ChooseYourCityViewController.self)
            case .chooseLocationOnMap:
                return ChooseLocationFromMapViewController()
            case .chooseService:
                return Storyboard.Service.viewController(for: ChooseYourServiceViewController.self)
            case .chooseSubService(service: let service):
                let vc = Storyboard.Service.viewController(for: ChooseSubServicesViewController.self)
                vc.service = service
                return vc
            case .chooseAddCustomService(service: let service):
                let vc = Storyboard.Service.viewController(for: AddCustomViewViewController.self)
                vc.service = service
                return vc
            case .addCustomCategory:
                return Storyboard.Service.viewController(for: CustomCategoryViewController.self)
            case.uploadProfilePicture:
                return Storyboard.Profile.viewController(for: UploadProfilePictureViewController.self)
            case.updateJob:
                return Storyboard.Profile.viewController(for: UpdateJobViewController.self)
            case .uploadIDProof:
                return Storyboard.Profile.viewController(for: UploadIDProofViewController.self)
            case .jobStatus:
                return Storyboard.Booking.viewController(for: BookingJobStatusViewController.self)
            case .cancelJobRequest:
                return Storyboard.Booking.viewController(for: CancelRequestViewController.self)
            case .notifications:
                return Storyboard.Profile.viewController(for: NotificationsViewController.self)
            case .paymentList:
                return Storyboard.Profile.viewController(for: PaymentListViewController.self)
            case .cancelPayment:
                return Storyboard.Profile.viewController(for: CancelPaymentViewController.self)
            case .logout:
                return Storyboard.Profile.viewController(for: LogoutViewController.self)
            case .choresID:
                return Storyboard.Profile.viewController(for: ChoresIDViewController.self)
            case .jobstatus:
                return Storyboard.Profile.viewController(for: ChoresIDViewController.self)
            case .providerList:
                return Storyboard.Profile.viewController(for: ProviderListViewController.self)
            case .ProfileTapped:
                return Storyboard.Profile.viewController(for: ProfileTapedViewController.self)
            case.checkOut:
                return Storyboard.Profile.viewController(for: CheckOutViewController.self)
            case.paymentMode:
                return Storyboard.Profile.viewController(for: PaymentModeViewController.self)
            case.HomePage:
                return Storyboard.Home.viewController(for: HomeViewController.self)
            case.DoneJob:
                return Storyboard.Home.viewController(for: AfterDoneHomeViewController.self)
            case.EditButtonTapped:
                return Storyboard.Menu.viewController(for: EditButtonClickedViewController.self)
            case.CancelReasonPage:
                return Storyboard.Profile.viewController(for: CancelResonViewController.self)
            case.Rating:
                return Storyboard.Booking.viewController(for: RatingAlertViewController.self)
                case .googleSignUp:
                    return Storyboard.Authentication.viewController(for: GoogleSignUpViewController.self)
                case .facebookSignUp:
                    return Storyboard.Authentication.viewController(for: FacebookSignUpViewController.self)
            }
        }else {
            // FIXME: Implement other `Navigation`
            fatalError("Implement")
        }
    }
    
    func navigate(_ navigation: Navigatable, from: UIViewController, to: UIViewController) {
        
        from.navigationController?.pushViewController(to, animated: true)
    }
    
    
}

//extension UIViewController {
//
//    func navigate(_ navigation: Navigation) {
//        navigate(navigation as Navigatable)
//    }
//}

extension UIViewController {
    func navigate(_ navigation: Navigation) {
        navigate(navigation as Navigatable)
        //        Router.default.navigate(navigation, from: self)
    }
    
    //    func present(_ navigation: Navigation) {
    //        Router.default.present(navigation, from: self)
    //    }
    
    //    func chageRootToHome() {
    //        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else {
    //            return
    //        }
    //        window.rootViewController = MainTabBarViewController()
    //        window.makeKeyAndVisible()
    //    }
}

