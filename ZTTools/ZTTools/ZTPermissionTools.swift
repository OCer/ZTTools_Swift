//
//  ZTPermissionTools.swift
//  XHSG
//
//  Created by Asuna on 2020/7/16.
//  Copyright © 2020 Asuna. All rights reserved.
//

import UIKit
import Photos

public final class ZTPermissionTools {

    /// 请求相册访问权限
    public class func checkPhotoLibraryPermission(_ completion: ((_ status: PHAuthorizationStatus) -> Void)? = nil) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    if let block = completion {
                        block(status)
                    }
                }
            
            default:
                if let block = completion {
                    block(status)
                }
        }
    }
    
    /// 判断用户是否打开了消息推送
    public class func isOpenMessageNotificationServiceWithBlock(_ completion: ((_ isOpen: Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if let block = completion {
                    block(settings.authorizationStatus == UNAuthorizationStatus.authorized)
                }
            }
        }
    }
}
