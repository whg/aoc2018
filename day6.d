import std.stdio;
import std.file;
import std.string;
import std.array;
import std.conv;
import std.algorithm;
import std.math;
import std.range;
import std.typecons;

alias id_t = ulong;
const id_t NO_ID = id_t.max;

alias Coord = Tuple!(id_t,"id", int,"x", int,"y");

int manhattan(Coord a, Coord b) {
	return abs(a.x - b.x) + abs(a.y - b.y);
}

void main()
{
	auto lines = "input/day6.txt".readText.splitLines;
	Coord[] coords;
	int mx = 0, my = 0;
	foreach (i, line; lines) {
		auto bits = line.split(", ");
		auto coord = Coord(i, bits[0].to!int, bits[1].to!int);
		mx = max(mx, coord.x + 1);
		my = max(my, coord.y + 1);
		coords ~= coord;
	}

	id_t[] closest_ids;
	closest_ids.length = mx * my;

	int[] distances;
	distances.length = mx * my;
	
	for (int y = 0; y < my; y++) {
		for (int x = 0; x < mx; x++) {
			Coord p = Coord(0, x, y);
			id_t closest_id;
			int min_dist = int.max;
			int total_dist = 0;
			foreach (coord; coords) {
				auto dist = manhattan(p, coord);
				total_dist += dist;
				if (dist < min_dist) {
					closest_id = coord.id;
					min_dist = dist;
				} else if (dist == min_dist) {
					closest_id = NO_ID;
				}
			}
			closest_ids[y * mx + x] = closest_id;
			distances[y * mx + x] = total_dist;
		}
	}

	auto id_counts = coords.map!(c => tuple(c.id, count(closest_ids, c.id))).assocArray;
	
	auto remove = (id_t id) => id_counts.remove(id);
	
	for (int x = 0; x < mx; x++) {
		remove(closest_ids[x]);
		remove(closest_ids[(my - 1) * mx + x]);
	}
	for (int y = 0; y < my; y++) {
		remove(closest_ids[y * mx]);
		remove(closest_ids[y * mx + mx - 1]);
	}

	writeln(id_counts.values.maxElement);
	
	auto under10k = distances.filter!(d => d < 10_000);
	writeln(under10k.count);
}
