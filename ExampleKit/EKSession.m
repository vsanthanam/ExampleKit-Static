//
//  EKSession.m
//  ExampleKit
//
//  Created by Varun Santhanam on 10/24/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#import "EKSession.h"

NSString * const EKSessionErrorDomain = @"EKSessionErrorDomain";
NSString * const EKSessionProcessingNotification = @"EKSessionProcessingNotification";

@implementation EKSession {
    
    BOOL _isProcessing;
    
}

@synthesize delegate = _delegate;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithDelegate:nil];
    
    return self;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<EKSessionDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        
    }
    
    return self;
    
}

- (BOOL)processObject:(EKObject *)object {
    
    // Do Not Allow Concurrent Processes
    if (_isProcessing) {
        
        return NO;
        
    }
    
    // Inform Delegate
    if ([self.delegate respondsToSelector:@selector(session:didBeginProcessingObject:)]) {
        
        [self.delegate session:self didBeginProcessingObject:object];
        
    }
    
    // Process
    [self _doSomeProcessingOnObject:object
                       completeWith:^(EKObject *processedObject, NSError *error) {
                           
                           // Inform Delegate
                           if ([self.delegate respondsToSelector:@selector(session:didFinishProcessingObject:withError:)]) {
                               
                               [self.delegate session:self
                            didFinishProcessingObject:processedObject
                                            withError:error];
                               
                           }
                           
                       }];
    
    return YES;
    
}

- (BOOL)processObject:(EKObject *)object withCompletionHandler:(void (^)(EKObject * _Nonnull, BOOL, NSError * _Nullable))completionHandler {
    
    // Do Not Allow Concurrent Processes
    if (_isProcessing) {
        
        return NO;
        
    }
    
    // Process
    [self _doSomeProcessingOnObject:object
                       completeWith:^(EKObject *processedObject, NSError *error) {
                           
                           // Call Completion Handler
                           if (completionHandler) {
                               
                               completionHandler(processedObject, !(BOOL)error, error);
                               
                           }
                           
                       }];
    
    return YES;
    
}

#pragma mark - Private Instance Methods

- (void)_doSomeProcessingOnObject:(EKObject *)objectToProcess completeWith:(void (^)(EKObject *processedObject, NSError *error))complete {
    
    // Block any incoming processes till this one finishes
    _isProcessing = YES;
    
    // Perform in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        // Check for characters
        NSCharacterSet *symbols = [NSCharacterSet symbolCharacterSet];
        NSError *error;
        if ([objectToProcess.objectName rangeOfCharacterFromSet:symbols].location != NSNotFound) {
         
            error = [NSError errorWithDomain:EKSessionErrorDomain code:-1 userInfo:nil];
            
        }
        
        // Wait 2 seconds, to simulate long-running task
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // Allow New Processes
            _isProcessing = NO;
            
            // Fire Notification
            [[NSNotificationCenter defaultCenter] postNotificationName:EKSessionProcessingNotification
                                                                object:error ? error : objectToProcess];
            
            // Call Completion On Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
               
                complete(objectToProcess, error);
                
            });
            
        });
        
    });
    
}

@end
