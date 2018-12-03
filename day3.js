let fs = require('fs');

let input = fs.readFileSync('input/day3.txt', 'utf8').split('\n').filter(l => {
	return l[0] === '#';
});

let claims = input.map(line => {
	let claim = {};
	let regex = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/;
	let bits = line.match(regex).slice(1, 6);
	['id', 'x', 'y', 'w', 'h'].forEach((e, i) => {
		claim[e] = parseInt(bits[i], 10);
	});
	return claim;
});

function Fabric() {
	let content = {};
	this.add = function(claim) {
		for (let i = 0; i < claim.w; i++) {
			for (let j = 0; j < claim.h; j++) {
				let key = (claim.x + i) + ',' + (claim.y + j);
				if (key in content) {
					content[key].push(claim.id);
				} else {
					content[key] = [claim.id];
				}
			}
		}
	};

	this.getMultiple = function() {
		return Object.values(content).filter(e => {
			return e.length > 1;
		});
	};

	function chain(stuff) {
		let output = [];
		stuff.forEach(e => {
			output.push.apply(output, e);
		});
		return output;
	}

	this.findIntact = function() {
		let idSet = new Set();
		chain(Object.values(content)).forEach(e => {
			idSet.add(e);
		});
		
		chain(this.getMultiple()).forEach(e => {
			idSet.delete(e);
		});

		return idSet.values();
	};
	
};

let fabric = new Fabric();
claims.forEach(fabric.add);

console.log(fabric.getMultiple().length);
console.log(fabric.findIntact());

