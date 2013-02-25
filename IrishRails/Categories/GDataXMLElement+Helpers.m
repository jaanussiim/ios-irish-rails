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
