# ProxImages

ProxImages is very simple. It will present the user with a map near their current location, as well as an overlay indicating a search radius. Tapping on the map anywhere will initiate a search through the WikiMedia API to find images near that tapped location. A visual indicator of the search radius being used is shown as an overlay on the map. Tapping the map will transiently update the

The original requirement was to use the Instagram API to perform geo-searches, but since June 2016, Instagram has restricted their API for requests that require `public_content` scope to "production" API keys only. In order to get a production API key and get out of sandboxing mode, you must go through Instagram's review and submission process. https://medium.com/@emersonthis/instagram-on-websites-the-new-landscape-62c91d733894#.41x3jq16x

As a fallback, the WikiMedia endpoint was chosen because it is public and open and does not require an OAuth2 flow or similar just to view public content. The only downside of this is that WikiMedia does not return location information for individual images, so no distance information can be displayed below each image post.

## Requirements

- Xcode 8.2.1 (Xcode 8.1 might also work)
- Swift

## Running

Open the workspace and run the 'ProxImages' target for any device. No other authentication is required at runtime.

## Locale Support

The application will respect the user's locale for displaying distances (km, mi, feet, etc).

## Dependencies

Dependencies were brought in using CocoaPods for speed. Carthage could have also been used, but requires more initial maintenance that CocoaPods does not have. For these specific dependencies below, they are small enough in file count that they could have simply been brought in manually.

The only third party components brought in to make this simpler was `Alamofire` and `AlamofireImage`. Having consulted on both of these components' original APIs with the author, I know this is a very solid, easy, and performant method of networking and image parsing. AlamofireImage specifically will implicitly handle and respect HTTP caching rules for use in table/collection view cells.

## Testing

There is no testing currently being employed in this application. I had originally planned to test the data model parsing and add some rudimentary UI tests simply using XCUITest, but issues with the Instagram API ate most of that time away. Parsing testing was slightly mitigated with parsing error reporting to the console. However, this is runtime testing and shouldn't really be considered "testing" at all.

Some form of "UI tests" would be required before production, regardless, especially for universal apps developed in multiple end-user languages, since the large number of screenshots needed to be taken before submission can be automated away.

## Potential Improvements 

- Page parsing for WikiMedia endpoints to get more results parsed in
- Mock JSON data for testing and injection into test targets
- Better dynamic layout and centering of image results for varying screen sizes
- Find an API that returns actual location information for images in order to display distance info (maybe Flickr). Flickr was not originally used over WikiMedia because their API requires authentication for public geo-searches, and I don't know anyone that uses Flickr.
- Tapping on an image shows the full image
