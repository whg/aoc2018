import java.util.ArrayList;
import java.util.HashMap;
import java.util.Collections;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

class Day13 {

	final static String orienations = ">v<^";
	final static HashMap<Character, Vector> directions = makeDirections();

	enum Turn {
		STRAIGHT(0), LEFT(-1), RIGHT(+1);
		final int value;
		Turn(int value) {
			this.value = value;
		}
	};
	final Turn[] turns = { Turn.LEFT, Turn.STRAIGHT, Turn.RIGHT };
	
	static HashMap<Character, Vector> makeDirections() {
		HashMap<Character, Vector> d = new HashMap<Character, Vector>();
		d.put('<', new Vector(-1, 0));
		d.put('>', new Vector(1, 0));
		d.put('^', new Vector(0, -1));
		d.put('v', new Vector(0, 1));
		return d;
	}

	static boolean isCart(Character c) {
		return directions.containsKey(c);
	}

	static char trackReplacement(Character c) {
		switch (c) {
		case '>':
		case '<':
			return '-';
		case 'v':
		case '^':
			return '|';
		}
		return ' '; // ?
	}

	final char[][] tracks;
	ArrayList<Cart> carts;
	boolean crashedOnce;
	
	Day13(String filename) throws IOException {
		byte[] bytes;
		try {
			File input = new File(filename);
			bytes = Files.readAllBytes(input.toPath());
		} catch (IOException e) {
			throw e;
		}
		String[] lines = new String(bytes).split("\n");
		int rows = lines.length;
		int cols = lines[0].length();
		tracks = new char[rows][cols];
		carts = new ArrayList<Cart>();
		for (int r = 0; r < rows; r++) {
			char[] row = lines[r].toCharArray();
			for (int x = 0; x < row.length; x++) {
				if (isCart(row[x])) {
					carts.add(new Cart(row[x], x, r));
					row[x] = trackReplacement(row[x]);
				}
			}
			tracks[r] = row;
		}
		crashedOnce = false;
	}

	ArrayList<Cart> getCarts() {
		Collections.sort(carts, (a, b) -> {
				return a.y == b.y ? a.x - b.x : a.y - b.y;
			});
		return carts;
	}

	class LastCart extends Exception {
		Vector pos;
		LastCart(Vector pos) {
			this.pos = pos;
		}
	}

	class Crash extends LastCart {
		Crash(Vector pos) {
			super(pos);
		}
	}
	

	void iterate() throws Crash, LastCart {
		ArrayList<Cart> toRemove = new ArrayList<Cart>();
		Crash firstCrash = null;
		
		for (Cart cart : getCarts()) {
			Vector dir = directions.get(cart.chr);
			cart.x += dir.x;
			cart.y += dir.y;
			char nextSpot = tracks[cart.y][cart.x];
			if (nextSpot == '+') {
				cart.doIntersection();
			} else if (nextSpot == '/') {
				if (trackReplacement(cart.chr) == '-') cart.turn(Turn.LEFT);
				else cart.turn(Turn.RIGHT);
			} else if (nextSpot == '\\') {
				if (trackReplacement(cart.chr) == '-') cart.turn(Turn.RIGHT);
				else cart.turn(Turn.LEFT);
			}

			for (Cart ocart : carts) {
				if (ocart != cart &&
					cart.x == ocart.x && cart.y == ocart.y) {
					firstCrash = new Crash(cart);
					toRemove.add(cart);
					toRemove.add(ocart);
				}
			}		   
		}

		for (Cart cart : toRemove) {
			carts.remove(cart);
		}

		if (!crashedOnce && firstCrash != null) {
			crashedOnce = true;
			throw firstCrash;
		} 
		else if (carts.size() == 1) {
			throw new LastCart(carts.get(0));
		}		 
	}


	
	static class Vector {
		int x, y;
		Vector(int x, int y) {
			this.x = x;
			this.y = y;
		}
	}

	class Cart extends Vector {
		Character chr;
		int turnCounter;
		Cart(Character chr, int x, int y) {
			super(x, y);
			this.chr = chr;
			turnCounter = 0;
		}

		void turn(Turn t) {	
			final int n = orienations.length();
			int i = orienations.indexOf(chr);
			i = (i + n + t.value) % n;
			chr = orienations.charAt(i);
		}

		void doIntersection() {
			turn(turns[turnCounter++  % turns.length]);
		}

	}


	public static void main(String[] args) {

		try {
			Day13 d = new Day13("input/day13.txt");
			try {
				while (true) {
					try {
						d.iterate();
					}
					catch (Crash c) {
						System.out.println(c.pos.x + "," + c.pos.y);
					}		
				}
			} 
			catch (LastCart c) {
				System.out.println(c.pos.x + "," + c.pos.y);				
			}
			
		}
		catch (IOException e) {}
	}
}
