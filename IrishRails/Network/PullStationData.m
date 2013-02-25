//
//  PullStationData.m
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "PullStationData.h"
#import "Station.h"
#import "GDataXMLNode.h"
#import "StationData.h"

@interface PullStationData ()

@property (nonatomic, strong) Station *station;
@property (nonatomic, copy) PullStationDataCompletionBlock completion;

@end

@implementation PullStationData

- (id)initWithStation:(Station *)station completionHandler:(PullStationDataCompletionBlock)completion {
  self = [super init];
  if (self) {
    _station = station;
    _completion = completion;
  }
  return self;
}

- (void)start {
  NSString *urlString = [NSString stringWithFormat:@"http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=%@", self.station.code];
  NSURL *url = [NSURL URLWithString:urlString];
  [self fetchDataFromURL:url];
}

- (NSString *)activityDescription {
  return [NSString stringWithFormat:@"Pulling data for %@...", self.station.name];
}

- (void)handleError:(NSError *)error {
  self.completion(nil, error);
}

- (void)parseResponse:(GDataXMLDocument *)document {
  NSArray *data = [StationData readStationData:document forStation:self.station];
  self.completion(data, nil);
}

@end
