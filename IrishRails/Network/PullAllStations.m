/*
 * Copyright 2013 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PullAllStations.h"
#import "GDataXMLNode.h"
#import "Station.h"

@interface PullAllStations ()

@property (nonatomic, copy) PullStationsCompletionBlock completion;

@end

@implementation PullAllStations

- (id)initWithCompletionHandler:(PullStationsCompletionBlock)completion {
  self = [super init];
  if (self) {
    _completion = completion;
  }
  return self;
}

- (NSString *)activityDescription {
  return NSLocalizedString(@"pulling.stations", nil);
}

- (void)start {
  [self fetchDataFromURL:[NSURL URLWithString:@"http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"]];
}

- (void)parseResponse:(GDataXMLDocument *)document {
  NSArray *stations = [Station readStations:document];
  self.completion(stations, nil);
}

- (void)handleError:(NSError *)error {
  self.completion(nil, error);
}

@end
