//
//  GDataXMLElement+Helpers.m
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "GDataXMLElement+Helpers.h"

@implementation GDataXMLElement (Helpers)

- (NSString *)firstValueForField:(NSString *)fieldName {
  NSArray *elements = [self elementsForName:fieldName];
  if ([elements count] > 0) {
    NSString *value = [[[elements objectAtIndex:0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return value;
  }

  return nil;
}

- (float)firstFloatValueForField:(NSString *)fieldName {
  NSString *value = [self firstValueForField:fieldName];
  return [value floatValue];
}

@end
