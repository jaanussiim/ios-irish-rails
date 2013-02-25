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

#import <CoreLocation/CoreLocation.h>
#import "Station.h"
#import "GDataXMLNode.h"
#import "Constants.h"
#import "GDataXMLElement+Helpers.h"

@implementation Station

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ {name:%@, code:%@, coordinate:%@}", NSStringFromClass([Station class]), self.name, self.code, [NSString stringWithFormat:@"(lon:%f - lat:%f)", self.coordinate.longitude, self.coordinate.latitude]];
}

+ (NSArray *)readStations:(GDataXMLDocument *)doc {
  NSError *err = nil;
  NSArray *nodes = [[doc rootElement] nodesForXPath:@"//_def_ns:ArrayOfObjStation/_def_ns:objStation" error:&err];
  if (err) {
    JSLog(@"pagesFromXMLDocument error:%@", err);
  } else {
    JSLog(@"Found %d nodes", [nodes count]);
  }

  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[nodes count]];
  for (GDataXMLElement *stationElement in nodes) {
    Station *station = [[Station alloc] init];
    [station setName:[stationElement firstValueForField:@"StationDesc"]];
    [station setCode:[stationElement firstValueForField:@"StationCode"]];
    float lat = [stationElement firstFloatValueForField:@"StationLatitude"];
    float lon = [stationElement firstFloatValueForField:@"StationLongitude"];
    [station setCoordinate:CLLocationCoordinate2DMake(lat, lon)];

    [result addObject:station];
  }

  return [NSArray arrayWithArray:result];
}

@end
