# Places

A SwiftUI app that shows a list of locations. Tapping one opens a modified Wikipedia app on its
Places tab, centred on that coordinate. You can also type your own coordinate.

## Requirements

| | |
|---|---|
| Xcode | 26.4 (Swift 6, strict concurrency) |
| Places | iOS 16.0+ |
| Modified Wikipedia | iOS 17.6+ (the fork's own deployment target) |

Places runs on iOS 16, but the fork needs iOS 17.6. So the full flow between the two apps only
works on an iOS 17.6+ simulator. The app and all its tests run on iOS 16.

## How to run

```sh
open Places.xcodeproj          # run the Places scheme on any simulator
./Scripts/fetch-wikipedia.sh   # download and configure the modified Wikipedia app
```

The script clones the fork into `ThirdParty/` (about 176 MB, ignored by git), pins it to a known
commit, and creates the signing config the project needs. Then open
`ThirdParty/wikipedia-ios/Wikipedia.xcodeproj`, run the **Wikipedia** scheme on an iOS 17.6+
simulator, and run Places on the same simulator.

When you tap a place, iOS asks for confirmation: *"Places" wants to open "Wikipedia"*. This is
normal system behaviour for switching apps, not an error. If the fork is not installed, the app
shows a message instead of doing nothing.

## Architecture

One app target, organised in folders by layer. Views know about view models, view models know about
protocols, and no code below the view layer imports SwiftUI.

```
App/          composition root - the only place that connects protocols to implementations
Features/     PlacesList and CustomPlace - each has a view and a view model
Repositories/ PlacesRepository, PlacesCache and their implementations
Networking/   HTTPClient and its URLSession implementation
Models/       Place, Coordinate, and the DTO that decodes the feed
Common/       ViewState, PlacesError, shared views for empty and error states
```

**MVVM with `ObservableObject`.** iOS 16 does not have `@Observable` or `ContentUnavailableView`,
so view models use `ObservableObject`, and the empty and error states are small custom views.

**One state instead of three flags.** Each screen has a `ViewState<Value>`: `loading`, `loaded` or
`failed`. This makes impossible combinations, like loading and failed at the same time, impossible
to write. There is no `empty` case - an empty list is just `loaded` with no items, and the screen
decides how to show it.

**Dependencies passed through initialisers.** `AppDependencies` is the only place where protocols
are connected to real implementations. Nothing uses a singleton, so every dependency can be replaced
in a test. It also builds a fixed set of dependencies when the app starts with `-uiTesting`, which
keeps the UI tests off the network.

## The deep link

```
wikipedia://places?lat=52.3547498&lon=4.8339215
```

The fork reads both values with `NSScanner` using `en_US_POSIX`, and the whole string must be a
number. So `WikipediaDeepLink` builds the coordinates with `String(format: "%.7f", value)`, which
ignores the device locale. Seven decimals is about one centimetre.

This is the easiest place to make a silent mistake. A locale-aware formatter would produce
`52,3547498` in Dutch or Russian. `Double.formatted()` is worse: by default it groups digits and
keeps only three decimals, so `52.3547498` becomes `52.355`. The fork would reject or cut either
one, and Wikipedia would open in the wrong place without any error. A test checks that the URL
never contains a comma.

Formatting for the screen is separate and does follow the locale: the list shows `52,3547` on a
Russian device, and VoiceOver reads two decimals, because seven are impossible to follow by ear.

## The data

`locations.json` has four entries, and the fourth one (Madrid) has no `name`. So `Place.name` is
optional, and the UI falls back to "Unnamed place". VoiceOver says the same. Entries with
coordinates outside ±90 or ±180 are skipped instead of breaking the whole list.

## Offline

Every successful load is saved to a JSON file in the caches directory. If a later load fails
**because the device is offline**, the saved list is shown with a banner. Any other failure, such as
a broken response or a server error, shows an error instead. Showing old data in place of a real
problem would confuse the user.

## Testing

58 unit tests (Swift Testing) and 4 UI tests (XCTest). Both pass on iOS 16.4 and iOS 26.4.

Unit tests cover coordinate validation, including limits, NaN and infinity; decoding the real
payload with the missing name; mapping status codes and `URLError`; building the deep link; parsing
user input; the cache; and all view model state changes.

Test doubles are in `PlacesTests/Utils`: a `URLProtocol` stub for the real `URLSession` client, and
simple fakes for everything else. Cancellation travels as `CancellationError` instead of becoming a
`PlacesError`, so a cancelled load leaves the screen as it is instead of showing an error.

UI tests start the app with `-uiTesting`, which provides fixed data, temporary storage, and a URL
opener that always fails. Without this, the "Wikipedia is missing" test would depend on what is
installed on the machine, and the empty form test on what the previous run left behind.

The UI tests were useful: one of them found that a list row only reacted to taps where the text was,
because the row had no tappable background.

## Accessibility

- A row is one element: *"Amsterdam, latitude 52.35, longitude 4.83"*, with the hint "Opens this
  place in Wikipedia" and the button trait.
- On an error, VoiceOver focus moves to the message. The message and the suggestion are combined,
  so they are read together.
- The offline banner posts an announcement, because it appears above content that was already read.
- The coordinate form uses `@FocusState` to move from latitude to longitude, and the valid range is
  a spoken hint, not only red text.
- Checked at the largest accessibility text size on iPhone SE: rows grow, text wraps, nothing is
  cut off.
- All user-facing text is in a String Catalog.

## Room to improve

- **Caching.** The decision to show cached data lives in the view model. A caching wrapper around
  `PlacesRepository` would be cleaner, but the view needs to know the data is old to show the
  banner, which means changing the repository's return type.
- **Modules.** The layers are separated by folders and discipline. A local Swift package would let
  the compiler enforce them, which is worth doing as the app grows.
- **Snapshot tests** for the empty, error and offline states.
- **Design.** The empty and error states use system symbols and could look better.
- **Localisation.** Everything is ready for translation, but only English is provided.
