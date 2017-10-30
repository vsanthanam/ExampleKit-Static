//
//  EKObject.m
//  ExampleKit
//
//  Created by Varun Santhanam on 10/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "EKObject.h"

@implementation EKObject

@synthesize objectName = _objectName;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithObjectName:@"ObjectName"];
    
    return self;
    
}

- (NSUInteger)hash {
    
    return _objectName.hash;
    
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        
        return YES;
        
    } else if ([object isKindOfClass:[EKObject class]]) {
        
        return [self isEqualToObject:(EKObject *)object];
        
    }
    
    return NO;
    
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    
    return YES;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_objectName forKey:NSStringFromSelector(@selector(objectName))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *objectName = (NSString *)[aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(objectName))];
    
    self = [self initWithObjectName:objectName];
    
    return self;
    
}

#pragma mark - NSSecureCopying

- (id)copyWithZone:(NSZone *)zone {
    
    return [[[self class] allocWithZone:zone] initWithName:[self->_objectName copyWithZone:zone]];
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithObjectName:(NSString *)objectName {
    
    self = [super init];
    
    if (self) {
        
        _objectName = objectName;
        
    }
    
    return self;
    
}

- (BOOL)isEqualToObject:(EKObject *)object {
    
    if (!object) {
        
        return NO;
        
    }
    
    BOOL equalObjectNames = [self->_objectName isEqualToString:object->_objectName];
    
    return equalObjectNames;
    
}

@end
