
//iPhoneX

import UIKit

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height
let kScreenNH = UIScreen.main.nativeBounds.height
//判断iPhoneX
let IS_IPHONE_X =  kScreenNH >= 2436 ? true : false

let kStatusBarH : CGFloat = IS_IPHONE_X ? 44 : 20
let kNavigationBarH : CGFloat = IS_IPHONE_X ? 88 : 64
let kTabbarH : CGFloat = IS_IPHONE_X ? 83 : 49

//let kStatusBarH : CGFloat = 20
//let kNavigationBarH : CGFloat = 44
//let kTabbarH : CGFloat = 44
