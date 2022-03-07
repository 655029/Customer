//
//  UserStoreSingleton.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 24/08/21.
//

import Foundation
class UserStoreSingleton: NSObject{
    static let `shared` = UserStoreSingleton()
    private override init() {}

    var userlat: Double?
    var userLong: Double?
    var fromnotification : Bool = false

    var categoryId: Int? {
        get{
            return (UserDefaults().object(forKey: "categoryId") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "categoryId")
        }
    }

    var categoryName: String?{
        get{
            return (UserDefaults().object(forKey: "categoryName") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "categoryName")
        }

    }

    var isLoggedIn : Bool?{
        get{
            return (UserDefaults().object(forKey: "isLoggedIn") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn")
        }
    }
    
    var userType : String?{
        get{
            return (UserDefaults().object(forKey: "userType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userType")
        }
    }
    var userToken : String?{
        get{
            return (UserDefaults().object(forKey: "userToken") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userToken")
        }
    }
    
    var phoneNumber : String? {
        get{
            return (UserDefaults().object(forKey: "phoneNumer") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "phoneNumer")
        }
    }
    
    var socailPhoneNumber : String?{
        get{
            return (UserDefaults().object(forKey: "socailPhoneNumber") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "socailPhoneNumber")
        }
    }

    var providerId : Int?{
        get{
            return (UserDefaults().object(forKey: "providerId") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "providerId")
        }
    }

    var profileImage : String?{
        get{
            return (UserDefaults().object(forKey: "profileImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "profileImage")
        }
    }
    
    var socailProfileImage : String?{
        get{
            return (UserDefaults().object(forKey: "socailProfileImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "socailProfileImage")
        }
    }
    
    var CatImage : String?{
        get{
            return (UserDefaults().object(forKey: "CatImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "CatImage")
        }
    }
    var name : String?{
        get{
            return (UserDefaults().object(forKey: "name") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "name")
        }
    }
    var lastname : String?{
        get{
            return (UserDefaults().object(forKey: "lastname") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "lastname")
        }
    }
    var userID : Int?{
        get{
            return (UserDefaults().object(forKey: "userID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userID")
        }
    }
    var email : String?{
        get{
            return (UserDefaults().object(forKey: "email") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "email")
        }
    }
    var OtpCode : String?{
        get{
            return (UserDefaults().object(forKey: "Otp") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Otp")
        }
    }

    var currentLat : Double?{
        get{
            return (UserDefaults().object(forKey: "currentLat") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLat")
        }
    }
    var currentLong : Double?{
        get{
            return (UserDefaults().object(forKey: "currentLong") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLong")
        }
    }
    var bookingID : Int?{
          get{
              return (UserDefaults().object(forKey: "bookingID") as? Int)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "bookingID")
          }
      }

     var fcmToken : String?{
           get{
               return (UserDefaults().object(forKey: "fcmToken") as? String)
           }set{
               UserDefaults.standard.setValue(newValue, forKey: "fcmToken")
           }
       }

    var CategoryImg : String?{
          get{
              return (UserDefaults().object(forKey: "CategoryImg") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "CategoryImg")
          }
      }
    var Token : String?{
          get{
              return (UserDefaults().object(forKey: "Token") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "Token")
          }

      }

    var RemoveToken : String?{
          get{
              return (UserDefaults().object(forKey: "Token") as? String)
          }set{
              UserDefaults.standard.removeObject(forKey: "Token")
          }

      }
    
    var isLocationEnbled : Bool?{
        get{
            return (UserDefaults().object(forKey: "isLocationEnbled") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isLocationEnbled")
        }
    }

    var userRating : Double?{
        get{
            return (UserDefaults().object(forKey: "userRating") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userRating")
        }
    }
    var PostalCode : String?{
          get{
              return (UserDefaults().object(forKey: "PostalCode") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "PostalCode")
          }
      }

    var DialCode : String?{
          get{
              return (UserDefaults().object(forKey: "DialCode") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "DialCode")
          }
      }

    var jobId : Int?{
          get{
              return (UserDefaults().object(forKey: "jobId") as? Int)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "jobId")
          }
      }

    var totalPrice : String?{
          get{
              return (UserDefaults().object(forKey: "totalPrice") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "totalPrice")
          }
      }

    var Address : String?{
          get{
              return (UserDefaults().object(forKey: "Address") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "Address")
          }
      }

    var cancelReason : String?{
          get{
              return (UserDefaults().object(forKey: "cancelReason") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "cancelReason")
          }
      }

    var realEstateLicenseNumber : String?{
          get{
              return (UserDefaults().object(forKey: "realEstateLicenseNumber") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "realEstateLicenseNumber")
          }
      }
    var mailingAddress : String?{
          get{
              return (UserDefaults().object(forKey: "mailingAddress") as? String)
          }set{
              UserDefaults.standard.setValue(newValue, forKey: "mailingAddress")
          }
      }
    var is24HourFormat : Bool?{
        get{
            return (UserDefaults().object(forKey: "is24HourFormat") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "is24HourFormat")
        }
    }
    var appleEmail : String?{
        get{
            return (UserDefaults().object(forKey: "appleEmail") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "appleEmail")
        }
    }
    var brokerageType : String?{
        get{
            return (UserDefaults().object(forKey: "brokerageType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "brokerageType")
        }
    }
}

/*
 # Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

 target 'Chores for me' do
   # Comment the next line if you don't want to use dynamic frameworks
   use_frameworks!

   # Pods for Chores for me
   pod 'IQKeyboardManagerSwift'
   pod 'SnapKit'
   pod 'Designable'
   pod 'SideMenu'
   pod 'ADCountryPicker'
   pod 'GoogleMaps'
   pod 'Alamofire', '~> 4.0'
   pod 'Toast-Swift'
   pod 'SDWebImage'
   pod 'SwiftyJSON', '~> 4.0'
   pod 'NVActivityIndicatorView', '~> 4.8.0'
   pod 'Firebase/Auth'
   pod 'FBSDKLoginKit'
   pod 'Firebase/Core'
   pod 'Firebase/Messaging'
   pod 'Firebase/DynamicLinks'
   pod 'Firebase/Database'
   pod 'SPPermissions/Camera'
   pod 'SPPermissions/Location'
   pod 'SPPermissions/Microphone'
   pod 'Cosmos'
   pod 'Stripe'
   pod 'GoogleSignIn', '~> 5.0.2'
   pod 'GooglePlaces'
   pod 'GooglePlacePicker'


 end

 */
