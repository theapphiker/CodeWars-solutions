# This Python program counts 
# the number of possible smartphone screenlocking patterns starting from a given first point, that have a given length,
# assuming a 3x3 screen.
# Link to challenge: https://www.codewars.com/kata/585894545a8a07255e0002f1

screen = {
    "A": ["B", "E", "D", "F", "H"],
    "B": ["A", "D", "E", "F", "C", "G", "I"],
    "C": ["B", "E", "F", "H", "D"],
    "D": ["A", "B", "C", "E", "H", "G", "I"],
    "E": ["A", "B", "C", "F", "I", "H", "G", "D"],
    "F": ["A", "B", "C", "E", "I", "H", "G"],
    "G": ["D", "B", "E", "H", "F"],
    "H": ["G", "D", "A", "E", "C", "F", "I"],
    "I": ["H", "D", "E", "B", "F"],
}


def get_blocked_letters(path, node):
    """Returns a previously blocked letter if the letter blocking the blocked letter
    is in the path and can be skipped over. The blocked letter is stored as a
    dictionary value and the keys are tuples that consist of the blocking letter
    and the node."""
    results = []
    blocked_letters = {
        ("B", "A"): "C",
        ("B", "C"): "A",
        ("E", "D"): "F",
        ("E", "F"): "D",
        ("E", "B"): "H",
        ("E", "H"): "B",
        ("E", "G"): "C",
        ("E", "C"): "G",
        ("E", "A"): "I",
        ("E", "I"): "A",
        ("H", "G"): "I",
        ("H", "I"): "G",
        ("F", "C"): "I",
        ("F", "I"): "C",
        ("D", "A"): "G",
        ("D", "G"): "A",
    }
    for k in blocked_letters:
        if k[0] in path and k[1] == node:
            results.append(blocked_letters[k])
    return results


def all_paths_count(starting_node, length, possible_paths, path):
    the_count = 0
    for next_node in possible_paths:
        if next_node not in path and (len(path) + 1) < length:
            new_path = path + [next_node]
            blocked_letters = get_blocked_letters(new_path, next_node)
            the_count += all_paths_count(
                next_node, length, screen[next_node] + blocked_letters, new_path
            )
        elif next_node not in path and (len(path) + 1) == length:
            the_count += 1
    return the_count


def count_patterns_from(firstPoint, length):
    if length > len(screen) or length == 0:
        return 0
    elif length == 1:
        return 1
    else:
        return all_paths_count(
            firstPoint, length, screen[firstPoint], path=[firstPoint]
        )
