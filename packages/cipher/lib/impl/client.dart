// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

/**
 * This library contains all out-of-the-box implementations of the interfaces provided in the API which are compatible only with
 * client side. It includes the [cipher.impl] library and extends it with more algorithms.
 *
 * You must call [initCipher] method before using this library to load all implementations into cipher's API factories.
 * There's no need to call [initCipher] from [cipher.impl] if you call [initCipher] from this library (though you can do it if
 * your project's layout needs it).
 */
library cipher.impl.client;

import "package:cipher/impl/base.dart" as base;


bool _initialized = false;

/// This is the initializer method for this library. It must be called prior to use any of the implementations.
void initCipher() {
  if( !_initialized ) {
    _initialized = true;
    base.initCipher();
    _registerEntropySources();
  }
}

void _registerEntropySources() {
  // This will, one day, have the implementation of EntropySource for browsers, based on mouse moves and key clicks.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dynamic _createOrNull( closure() ) {
  try {
   return closure();
  } on UnsupportedError catch( e ) {
    return null;
  }
}
