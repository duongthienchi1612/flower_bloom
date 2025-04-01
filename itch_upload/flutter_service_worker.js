'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "922bfe92bf6bbcbde196c90e30446fb1",
"version.json": "181fcc1d5c000fb78c986eadeb24bfaf",
"index.html": "c0d7a3d3748e65238c8fb3703403a8d2",
"/": "c0d7a3d3748e65238c8fb3703403a8d2",
"main.dart.js": "cfdfd70d03b0a767e3c8398c085463bd",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"manifest.json": "ecd2a8214d3cbaf9611d474475d1dc04",
"assets/AssetManifest.json": "f1f0a59079c40b2924b418a042fd4bdc",
"assets/NOTICES": "af2a50bd5a825f4d804cfe76f4e29c29",
"assets/FontManifest.json": "c151b323372cc15d1c6611b48c0ac923",
"assets/AssetManifest.bin.json": "d7ffe3bc8eb6c7aa94e0d8fcc0a622f3",
"assets/packages/window_manager/images/ic_chrome_unmaximize.png": "4a90c1909cb74e8f0d35794e2f61d8bf",
"assets/packages/window_manager/images/ic_chrome_minimize.png": "4282cd84cb36edf2efb950ad9269ca62",
"assets/packages/window_manager/images/ic_chrome_maximize.png": "af7499d7657c8b69d23b85156b60298c",
"assets/packages/window_manager/images/ic_chrome_close.png": "75f4b8ab3608a05461a31fc18d6b47c2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "de78517a801c51262738c8e5edfc37cb",
"assets/fonts/MaterialIcons-Regular.otf": "364afa0148f525102e983c158b982107",
"assets/assets/images/name_back.png": "0b5825efbe4038494dd9b20d1c7956fb",
"assets/assets/images/ic_star_active.png": "542e449f51a88c56380bce4f9c2c9fdd",
"assets/assets/images/img_loading_50.png": "75674904fb1086b68e1bf6f2231eec97",
"assets/assets/images/ic_reload.png": "e030e99048d2495f80260db0515cdd26",
"assets/assets/images/app_icon.png": "843371c403c87bd3653b0486db1f68ea",
"assets/assets/images/ic_home.png": "585d64284aa04a331c99888a1718840a",
"assets/assets/images/ic_star_unactive.png": "fb6c86be981981ce9b01bcedf357adf2",
"assets/assets/images/ic_level_number.png": "62c0b5358366e3000edff974374839de",
"assets/assets/images/img_loading_100.png": "aaebac5696b33bf10b8afef41f9d73e2",
"assets/assets/images/ic_sound_on.png": "9e1024e2ac205ce2c0434c8eb3b36d35",
"assets/assets/images/ic_level_lock.png": "a3990854c73280a54f7a68dc3566728d",
"assets/assets/images/background.png": "4d992f4cccf8505a0d9b28979211983e",
"assets/assets/images/button_back.png": "a64bfb702f8809745a55745efe8803c5",
"assets/assets/images/img_loading_0.png": "d211214f36a577be792b62f9b126691a",
"assets/assets/images/ic_menu_level.png": "0c046cd569f66595da6dee71c23b9610",
"assets/assets/images/ic_play.png": "d26c80a08232ae9164a5478c5a0035f7",
"assets/assets/images/lottie/leaf.json": "1fd30824540c709170592ef10e0fcd8d",
"assets/assets/images/lottie/flower_bloom.json": "ac69431ee4a0e67f8e31c8a79dc07d0f",
"assets/assets/images/ic_sound_off.png": "27bd02db69d959a1cb63e2d3873dbe3b",
"assets/assets/images/ic_star_3.png": "c86996e67d0db689e17bfa6e3092ab5e",
"assets/assets/images/ic_star_2.png": "0db2f7e9be88dad1c7cf4b7877677d92",
"assets/assets/images/ic_play_text.png": "fc4ede1f14ad4070172651b312f0881f",
"assets/assets/images/ic_star_0.png": "b0b1f8ed9358faca306e3b6136e22565",
"assets/assets/images/ic_star_1.png": "d50eeb76362c61694a42029dc6e32941",
"assets/assets/images/ic_btn_theme.png": "d9421594dcbf2b26814ca2079a681b90",
"assets/assets/images/back.png": "04790fe129fac830b126a53974db5ffd",
"assets/assets/sounds/background_music.mp3": "ead5c7cec5cc1b8b6120522928fddfc6",
"assets/assets/sounds/game_appear.mp3": "b4e153367620a9dbc02b3c11ae9069ac",
"assets/assets/sounds/bloom_source.mp3": "c2dae341f86c1237a19396a02bf8726e",
"assets/assets/sounds/click.mp3": "7a9dd9e657312ac9781ab63ccbf73166",
"assets/assets/sounds/completed.mp3": "d375e57d2a5c1762c1b98333aeb78cfa",
"assets/assets/sounds/level_appear.mp3": "82fb2bb41ae7f5b51e9bc882c11d6319",
"assets/assets/sounds/level_appear_source.mp3": "09d491ed778d9bf076626f6b2c3c4f74",
"assets/assets/sounds/flower_bloom.mp3": "2604e4a20d9b05e4aa007e1724301cc1",
"assets/assets/fonts/Bungee.otf": "13a2880ff85509e2717f0d7840225aac",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
