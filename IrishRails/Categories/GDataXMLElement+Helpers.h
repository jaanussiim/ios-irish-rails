//
//  GDataXMLElement+Helpers.h
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLElement (Helpers)

- (NSString *)firstValueForField:(NSString *)fieldName;
- (float)firstFloatValueForField:(NSString *)fieldName;

@end
