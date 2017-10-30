//
//  EKSession.h
//  ExampleKit
//
//  Created by Varun Santhanam on 10/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

@import Foundation;

#import "EKObject.h"

extern NSString * _Nonnull const EKSessionErrorDomain;
extern NSString * _Nonnull const EKSessionProcessingNotification;

@class EKSession;

@protocol EKSessionDelegate <NSObject>

@optional

- (void)session:(nonnull EKSession *)session didBeginProcessingObject:(nonnull EKObject *)object;
- (void)session:(nonnull EKSession *)session didFinishProcessingObject:(nonnull EKObject *)object withError:(nullable NSError *)error;

@end

@interface EKSession : NSObject

@property (weak, nullable) id<EKSessionDelegate> delegate;

- (nullable instancetype)initWithDelegate:(nullable id<EKSessionDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)processObject:(nonnull EKObject *)object;

- (BOOL)processObject:(nonnull EKObject *)object withCompletionHandler:(void (^_Nullable)(EKObject * _Nonnull object, BOOL success, NSError * _Nullable error))completionHandler;

@end
