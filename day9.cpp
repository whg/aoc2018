#include <iostream>
#include <list>
#include <vector>
#include <algorithm>

size_t play(int numPlayers, int lastMarble) {
	std::list<size_t> circle{0};
	auto it = circle.begin();
	std::vector<size_t> scores(numPlayers, 0);
	size_t player = 0;
	for (size_t marble = 1; marble <= lastMarble; marble++) {
		if (marble % 23 == 0) {
			for (int i = 0; i < 8; i++) {
				if (--it == circle.begin()) {
					it = circle.end();
				}
			}
			scores[player] += marble + *it;
			it = circle.erase(it);
			if (++it == circle.end()) {
				it = circle.begin();
			}
		} else {
			if (++it == circle.end()) {
				it = circle.begin();
				circle.push_back(marble);
			} else {
				circle.insert(it, marble);
			}
		}
		player = (player + 1) % numPlayers;
	}
	return *std::max_element(scores.begin(), scores.end());
}

int main() {
	std::cout << play(405, 70953) << std::endl;
	std::cout << play(405, 7095300) << std::endl;
	return 0;
}
