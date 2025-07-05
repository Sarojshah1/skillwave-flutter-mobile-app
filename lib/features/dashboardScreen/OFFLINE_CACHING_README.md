# Dashboard Offline Caching with Hive

This implementation provides LRU (Least Recently Used) caching for dashboard posts using Hive, allowing users to view cached posts when offline.

## Features

- **LRU Caching**: Stores up to 3 most recent posts
- **Offline Support**: Displays cached posts when network is unavailable
- **Automatic Cache Management**: Removes old posts when cache limit is reached
- **Cache Validation**: Cache expires after 1 hour
- **Seamless Integration**: Works with existing repository pattern

## Architecture

### Components

1. **DashboardLocalDatasource**: Handles local storage operations
2. **DashboardRepositoryImpl**: Orchestrates remote and local data sources
3. **OfflineHelper**: Utility class for offline functionality
4. **HiveService**: Manages Hive initialization

### Data Flow

1. **Online Mode**:
   - Fetch data from remote API
   - Cache the response locally
   - Return fresh data to UI

2. **Offline Mode**:
   - Try remote API (fails)
   - Fallback to cached data
   - Return cached data to UI

## Usage

### Basic Usage

```dart
// In your bloc or service
class DashboardService {
  final DashboardRepository _repository;
  final OfflineHelper _offlineHelper;

  DashboardService(this._repository) : _offlineHelper = OfflineHelper(_repository);

  Future<PostsResponseEntity> getPosts(GetPostsDto dto) async {
    try {
      // This will automatically handle offline/online logic
      return await _repository.getPosts(dto);
    } catch (e) {
      // If both remote and cache fail, check if we have offline data
      if (_offlineHelper.hasCachedPosts()) {
        return _offlineHelper.getOfflinePostsResponse();
      }
      rethrow;
    }
  }
}
```

### Check Offline Status

```dart
// Check if user is offline but has cached data
if (_offlineHelper.isOfflineWithData()) {
  // Show offline indicator
  showOfflineBanner(_offlineHelper.getOfflineMessage());
}
```

### Manual Cache Management

```dart
// Clear all cached data
await _offlineHelper.clearOfflineData();

// Get number of cached posts
int cachedCount = _offlineHelper.getCachedPostsCount();
```

## Configuration

### Cache Settings

- **Max Cache Size**: 3 posts (configurable in `DashboardLocalDatasource._maxCacheSize`)
- **Cache Expiry**: 1 hour (configurable in `isCacheValid()` method)
- **Storage**: Hive box named `dashboard_posts_box`

### Customization

To modify cache behavior, update these constants in `DashboardLocalDatasource`:

```dart
static const int _maxCacheSize = 3; // Change cache size
static const int _cacheExpiryHours = 1; // Change expiry time
```

## Error Handling

The implementation includes proper error handling:

- **CacheFailure**: Thrown when cache operations fail
- **Graceful Fallback**: Falls back to cached data when remote fails
- **Validation**: Checks cache validity before using cached data

## Testing

### Test Offline Functionality

1. **Enable Airplane Mode** on device
2. **Load Dashboard** - should show cached posts
3. **Check Offline Message** - should display "You are currently offline..."

### Test Cache Management

```dart
// Test cache operations
final localDatasource = DashboardLocalDatasource();
await localDatasource.init();

// Add test posts
await localDatasource.cachePosts(testPosts);

// Verify cache
final cached = localDatasource.getCachedPosts();
assert(cached.length <= 3); // LRU limit
```

## Integration with Existing Code

The implementation is designed to work seamlessly with existing code:

- **Repository Pattern**: Extends existing repository interface
- **Dependency Injection**: Uses `@LazySingleton` for proper DI
- **Error Handling**: Maintains existing error handling patterns
- **Type Safety**: Uses existing entity and model types

## Performance Considerations

- **Memory Efficient**: LRU algorithm prevents memory bloat
- **Fast Access**: Hive provides fast local storage
- **Minimal Overhead**: Cache operations are lightweight
- **Automatic Cleanup**: Expired cache is automatically cleared

## Future Enhancements

- **Background Sync**: Sync cached changes when online
- **Selective Caching**: Cache based on user preferences
- **Compression**: Compress cached data for storage efficiency
- **Analytics**: Track cache hit/miss rates 