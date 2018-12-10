(ns day10.core
  (:import [processing.core PVector])
  (:require [quil.core :as q]))


(defn load-points [filename]
  (def regex #"position=<\s?(-?\d+),\s+(-?\d+)> velocity=<\s?(-?\d+),\s+(-?\d+)>")
  (let [lines (clojure.string/split (slurp "../input/day10.txt") #"\n")
        bits (map (fn [line]
                    (map read-string (rest (re-matches regex line))))
                    lines)]
    (map (fn [[x y v w]] {:pos (PVector. x y), :vel (PVector. v w)}) bits)))

(defn setup []
  (q/set-state!
   :points (load-points "d10.txt")
   :step 10600) ;; by looking at the numbers a bit...
  (q/stroke 255))

;; key the up/down keys until we see something
;; should have found the minimum bounding box of the points

(defn draw []
  (q/background 0)
  (def scale 4)
  (doseq [point (q/state :points)]
    (let [pos (.copy (:pos point))
          vel (.copy (:vel point))]
      (.mult pos scale)
      (.mult vel (q/state :step))
      (.mult vel scale)
      (.add pos vel)
      (q/rect (.x pos) (.y pos) scale scale))))

(defn key-pressed []
  (case (q/key-as-keyword)
    :up (swap! (q/state-atom) update-in [:step] inc)
    :down (swap! (q/state-atom) update-in [:step] dec))
  (println (q/state :step)))

(defn -main [& args]
  (q/sketch
   :setup setup
   :draw draw
   :size [1000 800]
   :features [:exit-on-close]
   :key-pressed key-pressed))


