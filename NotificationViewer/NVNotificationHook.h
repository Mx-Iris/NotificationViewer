//
//  NVNotificationHook.h
//  NotificationViewer
//
//  Created by JH on 11/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern void _CFXNotificationPost(CFNotificationCenterRef center, id notification, BOOL deliverImmediately);

@interface NVNotificationHook : NSObject

@property (class, nonatomic, readonly) NVNotificationHook *sharedHook;
@property (readonly) NSArray<NSNotification *> *notifications;


@end

NS_ASSUME_NONNULL_END
