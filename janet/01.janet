(use judge)

(def sample (string/trim (slurp "../input/01.sample")))
(def input (string/trim (slurp "../input/01.input")))

########################################

(def peg
  ~{:line (* (number :d+) :s+ (number :d+))
    :main (split "\n" (group :line))})

(test (peg/match peg sample)
  @[@[3 4]
    @[4 3]
    @[2 5]
    @[1 3]
    @[3 9]
    @[3 3]])

########################################

(defn part-1 [input] input
  (defn diff [val] (math/abs (- (first val) (last val))))
  (def matched-input (peg/match peg input))
  (def left (map first matched-input))
  (def right (map last matched-input))
  (reduce + 0 (map diff (map tuple (sort left) (sort right)))))

(test (part-1 sample) 11)
(test (part-1 input) 1834060)

########################################

(defn part-2 [input] input
  (def matched-input (peg/match peg input))
  (def left (map first matched-input))
  (def right (map last matched-input))
  (def similarities (frequencies right))
  (reduce + 0 (map (fn [x] (* x (get similarities x 0))) left)))

(test (part-2 sample) 31)
(test (part-2 input) 21607792)
