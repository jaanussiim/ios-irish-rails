//
//  PullStationData.h
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkOperation.h"

@class Station;

typedef void (^PullStationDataCompletionBlock)(NSArray *data, NSError *error);


@interface PullStationData : NetworkOperation

- (id)initWithStation:(Station *)station completionHandler:(PullStationDataCompletionBlock)completion;

@end
