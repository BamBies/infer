/*
 * Copyright (c) 2016 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import "FakeComponentKitHeader.h"

@interface CKLabelComponent : CKCompositeComponent
+ (instancetype)newWithLabelAttributes:(LabelAttributes)labelAttributes
                        viewAttributes:(ViewAttributes)viewAttributes
                                  size:(CKSize)size;
@end
@implementation CKLabelComponent
+ (instancetype)newWithLabelAttributes:(LabelAttributes)labelAttributes
                        viewAttributes:(ViewAttributes)viewAttributes
                                  size:(CKSize)size {
  return nil;
}
@end

// Non-component class should be linted if in the same translation unit as a
// component or controllerimplementation
@interface SomeClass : NSObject
@end
@implementation SomeClass {
  NSString* _foo;
}

- (instancetype)init {
  if (self = [super init]) {
    NSString* foo = @"HI"; // error
    _foo = foo;
  }
}
@end

@interface FooComponent : CKCompositeComponent
@end
@implementation FooComponent
+ (instancetype)newWithString:(NSString*)string {
  // Built-in types
  int builtin1 = 3; // error
  const int builtin2 = 4; // no error
  int const builtin3 = 1; // no error

  // Objc types
  NSString* a = @"lol"; // error
  NSString* const b = @"lol"; // no error
  const NSString* c = @"lol"; // error
  const NSString* const d = @"lol"; // no error

  // Typedef resolution
  BOOL e = YES; // error
  const BOOL f = YES; // no error

  // Pointer types
  NSError* const error = nil; // no error
  NSError* const* g = &error; // error
  NSError* const* const h = &error; // no error

  return [super newWithComponent:[CKLabelComponent newWithLabelAttributes:{
                  .string = [@[ a, b, c, d ] componentsJoinedByString:@", "],
                }
                                     viewAttributes:{}
                                     size:{}]];
}
@end

class BarClass {
 public:
  int a;
};

@interface BarComponent : CKCompositeComponent
@end
@implementation BarComponent
+ (instancetype) new {
  // C++ classes
  BarClass s1; // error
  const BarClass& s2 = s1; // no error
  BarClass& s3 = s1; // error
  const BarClass s4 = {.a = 3}; // no error
}
@end
