var CoordinateCache = function() {
	this._items = {};
	this.hits = 0;
	this.misses = 0;
};

CoordinateCache.prototype.read = function(group, key, callback) {
	var miss = false;

	if (typeof this._items[group] === "undefined") {
		this._items[group] = {};
		this._items[group][key] = callback.call();
		console.log("Cache miss1g: " + group);
		console.log("Cache miss1r: ", this._items[group][key]);
		miss = true;
	} else if (typeof this._items[group][key] === "undefined") {
		this._items[group][key] = callback.call();
		console.log("Cache miss2g: " + group);
		console.log("Cache miss2r: ", this._items[group][key]);
		miss = true;
	}
	if (miss) {
		this.misses++;
	} else {
		this.hits++;
	}
	return this._items[group][key];
};

CoordinateCache.prototype.stats = function() {
	return {
		hits: this.hits,
		misses: this.misses
	};
};

window.CoordinateCache = CoordinateCache;