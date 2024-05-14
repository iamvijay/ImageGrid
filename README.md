# Image Grid

This implementation is designed to efficiently load and display images in an asynchronous manner within a scrollable grid view. By utilizing asynchronous loading techniques, the system ensures that the UI remains responsive and free from any lag or freezing during user interaction. This approach enhances the user experience by providing a smooth scrolling experience even while heavy image data is being fetched and rendered on the fly.

## Features

- **Home Feed:** It lists the JSON from the API, The Image has been cached also you can choose the segment where i am sending the limit based on segment selection(Default limit is 100).
- **Detail View:** View detailed information about coverage, just coverage title and published details along with opening web view to read.

## Taks list

- All Images are shown as 3 columns square grid with centre cropped
- Image loaded asynchronously, user can scroll 100, 200 or 300 images while scrolling (Choose 100 or 200 or 300 in the list at the top, UI will be refreshed with new data)
- The caching mechanism has been implemented, and will be stored in cache and disk, if not in cache will be moved to cache from disk otherwise will be downloaded and stored in both.
- If image loading fails or takes time to load place holder image will be shown.
- CPU usage and memory have been reduced by resizing images.

## Getting Started

To get started with Image Grid, follow these steps:

1. Clone this repository.
2. Open the project in Xcode.
3. Build and run the app on your iOS device or simulator.

## Screenshots
![Simulator Screenshot - iPhone 15 Pro - 2024-05-14 at 19 30 34](https://github.com/iamvijay/ImageGrid/assets/7961006/d4aa796b-fbad-44b2-b02e-36d2736af493)
![Simulator Screenshot - iPhone 15 Pro - 2024-05-14 at 19 30 50](https://github.com/iamvijay/ImageGrid/assets/7961006/60102171-5c99-4b36-b872-c3616a1b8bf1)

# License

 The MIT License (MIT)
 
 Copyright (c) 2024 Vijay Subramaniyam
 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
