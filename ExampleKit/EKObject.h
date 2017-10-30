//
//  EKObject.h
//  ExampleKit
//
//  Created by Varun Santhanam on 10/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface EKObject : NSObject<NSSecureCoding, NSCopying>

@property (NS_NONATOMIC_IOSONLY, copy, readonly, nonnull) NSString *objectName;

- (nullable instancetype)initWithObjectName:(nonnull NSString *)objectName NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToObject:(nullable EKObject *)object;

@end
