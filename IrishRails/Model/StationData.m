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

#import "StationData.h"
#import "GDataXMLNode.h"
#import "Constants.h"
#import "Station.h"
#import "GDataXMLElement+Helpers.h"

@implementation StationData

+ (NSArray *)readStationData:(GDataXMLDocument *)doc forStation:(Station *)station {
  NSError *err = nil;
  NSArray *nodes = [[doc rootElement] nodesForXPath:@"//_def_ns:ArrayOfObjStationData/_def_ns:objStationData" error:&err];
  if (err) {
    JSLog(@"pagesFromXMLDocument error:%@", err);
  } else {
    JSLog(@"Found %d nodes", [nodes count]);
  }

  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[nodes count]];
  for (GDataXMLElement *dataElement in nodes) {
    StationData *data = [[StationData alloc] init];

    [data setStation:station];
    [data setDueIn:[dataElement firstValueForField:@"Duein"]];
    [data setOrigin:[dataElement firstValueForField:@"Origin"]];
    [data setDestination:[dataElement firstValueForField:@"Destination"]];

    [result addObject:data];
  }

  return [NSArray arrayWithArray:result];
}

@end
