using System;
using System.Collections.Generic;
using System.Linq;

public class Day8 {
    public class Node {
        Node[] children;
        public int[] meta;

        public void AddChildren(int num) {
            children = new Node[num];
            for (int i = 0; i < num; i++) {
                children[i] = new Node();
            }
        }

        public ref Node GetChild(int i) { return ref children[i]; }
        public int GetNumChildren() { return children.Length; }
    }

    Node root;
    Day8() {
        root = new Node();
    }

    void Create(ref List<int> numbers, ref Node node) {
        node.AddChildren(numbers.First());
        numbers.RemoveAt(0);
        node.meta = new int[numbers.First()];
        numbers.RemoveAt(0);

        for (int i = 0;i <  node.GetNumChildren(); i++) {
            ref Node child = ref node.GetChild(i);
            Create(ref numbers, ref child);
        }

        for (int i = 0; i < node.meta.Length; i++) {
            node.meta[i] = numbers.First();
            numbers.RemoveAt(0);
        }
    }

    int Part1(ref Node node) {
        int sum = node.meta.Sum();
        for (int i = 0; i < node.GetNumChildren(); i++) {
            ref Node child = ref node.GetChild(i);
            sum += Part1(ref child);
        }
        return sum;
    }

    int Part2(ref Node node) {
        int sum = 0;
        if (node.GetNumChildren() == 0) {
            sum = node.meta.Sum();
        } else {
            foreach(int meta in node.meta) {
                int index = meta - 1;
                if (index < node.GetNumChildren()) {
                    ref Node child = ref node.GetChild(index);
                    sum += Part2(ref child);
                }
            }
        }
        return sum;
    }

    static public void Main() {
        String input = System.IO.File.ReadAllText("input/day8.txt");
        List<int> numbers = new List<int>(Array.ConvertAll(input.Split(" "), Int32.Parse));

        Day8 day8 = new Day8();
        day8.Create(ref numbers, ref day8.root);
        int part1 = day8.Part1(ref day8.root);
        Console.WriteLine(part1);
        int part2 = day8.Part2(ref day8.root);
        Console.WriteLine(part2);
    }
}
