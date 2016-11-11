image-preview-ios-demo
============
[![Build Status](https://travis-ci.org/GaborWnuk/image-preview-ios-demo.svg?branch=master)](https://travis-ci.org/GaborWnuk/image-preview-ios-demo)

Demonstration implementation of Image Preview technique - to achieve fast image previews immediately as placeholders, using around 200 bytes of image data.

Mechanism was described by [Facebook in August 2015](https://code.facebook.com/posts/991252547593574/the-technology-behind-preview-photos/).

Demo is based on [Clean Swift Architecture](http://clean-swift.com/clean-swift-ios-architecture/) by Raymond Law.

## Preview

Preview below was prepared on 2G, high latency connection. Blurred preview is delivered immediately with article data (in GraphQL response), with 190 bytes JPG file (with 620 bytes of headers trimmed and added on clients side).

![Preview](preview_z.gif)
