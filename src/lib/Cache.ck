public class IconCache {
    static Texture cache[0];
    static string _insertionOrder[0];
    static int _evictIdx;
    256 => static int MAX_SIZE;

    fun static void set(string key, Texture tex) {
        // If key already in cache, just update the texture
        if (cache.isInMap(key)) {
            tex @=> cache[key];
            return;
        }
        // Evict oldest if at capacity
        while (cache.size() >= MAX_SIZE && _evictIdx < _insertionOrder.size()) {
            cache.erase(_insertionOrder[_evictIdx]);
            _evictIdx++;
        }
        // Compact insertion order array if front half is stale
        if (_evictIdx > 0 && _evictIdx >= _insertionOrder.size() / 2) {
            string temp[0];
            for (_evictIdx => int i; i < _insertionOrder.size(); i++) {
                temp << _insertionOrder[i];
            }
            temp @=> _insertionOrder;
            0 => _evictIdx;
        }
        tex @=> cache[key];
        _insertionOrder << key;
    }

    fun static Texture get(string key) {
        return cache[key];
    }

    fun static void remove(string key) {
        cache.erase(key);
    }

    fun static void clear() {
        cache.clear();
        _insertionOrder.clear();
        0 => _evictIdx;
    }

    fun static int size() {
        return cache.size();
    }
}
